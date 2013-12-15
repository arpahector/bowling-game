require 'spec_helper'

feature "first ball of a frame" do
  context "when strike" do
    it "should move to a new frame" do
      previous_frame = Frame.number
      visit root_path
      fill_in "ball_pins", with: "10"
      click_button "See score"
      expect(page).to have_content "Frame: " + (previous_frame + 1).to_s
    end

    it "should return a score" do
      visit root_path
      fill_in "ball_pins", with: "7"
      click_button "See score"
      expect(page).to have_content "Score: 7"
    end

    it "score should take into account the next two balls" do
      visit root_path
      fill_in "ball_pins", with: "10"
      click_button "See score"
      expect(page).to have_content "Score: 10"

      fill_in "ball_pins", with: "7"
      click_button "See score"
      expect(page).to have_content "Score: 24"

      fill_in "ball_pins", with: "2"
      click_button "See score"
      expect(page).to have_content "Score: 28"
    end
  end

  context "when no strike" do
    it "shouldn't move to a new frame" do
      previous_frame = Frame.number
      visit root_path
      fill_in "ball_pins", with: "7"
      click_button "See score"
      expect(page).to have_content "Frame: " + previous_frame.to_s
    end
  end
end

feature "second ball of a frame" do
  background do
    visit root_path
    fill_in "ball_pins", with: "0"
    click_button "See score"
  end

  context "regardless of being a spare" do
    it "should move to a new frame" do
      previous_frame = Frame.number
      visit root_path
      fill_in "ball_pins", with: "7"
      click_button "See score"
      expect(page).to have_content "Frame: " + (previous_frame + 1).to_s
    end
  end

  context "when spare" do
    it "score should only take into account the next ball" do
      visit root_path
      fill_in "ball_pins", with: "10"
      click_button "See score"
      expect(page).to have_content "Score: 10"

      fill_in "ball_pins", with: "7"
      click_button "See score"
      expect(page).to have_content "Score: 24"

      fill_in "ball_pins", with: "2"
      click_button "See score"
      expect(page).to have_content "Score: 26"
    end
  end
end

feature "thenth frame" do
  background do
    visit root_path
    18.times do
      fill_in "ball_pins", with: "3"
      click_button "See score"
    end
  end

  context "when no strike or spare" do
    it "the game is over" do
      fill_in "ball_pins", with: "3"
      click_button "See score"

      fill_in "ball_pins", with: "3"
      click_button "See score"

      expect(page).to have_content "Game Over"
    end
  end

  context "when strike" do
    it "the player may throw two more balls" do
      fill_in "ball_pins", with: "10"
      click_button "See score"

      fill_in "ball_pins", with: "3"
      click_button "See score"

      fill_in "ball_pins", with: "3"
      click_button "See score"
      expect(page).to have_content "Game Over"
      expect(Ball.second_to_last.strike?).to be false
      expect(Ball.last.strike?).to be false
      expect(page).to have_content "Score: " + (18*3 + 10 + 6*2).to_s
    end

    it "and another strike it scores properly" do
      fill_in "ball_pins", with: "10"
      click_button "See score"

      fill_in "ball_pins", with: "10"
      click_button "See score"

      fill_in "ball_pins", with: "3"
      click_button "See score"
      expect(page).to have_content "Game Over"
      expect(page).to have_content "Score: " + (18*3 + 10 + 20 + 3*3).to_s
    end
  end

  context "when spare" do
    it "the player may throw one more ball" do
      fill_in "ball_pins", with: "7"
      click_button "See score"

      fill_in "ball_pins", with: "3"
      click_button "See score"

      fill_in "ball_pins", with: "2"
      click_button "See score"
      expect(Frame.last.balls.size).to be 3
      expect(Frame.count).to be 10
      expect(Frame.number).to be 11
      expect(page).to have_content "Game Over"
    end
  end
end

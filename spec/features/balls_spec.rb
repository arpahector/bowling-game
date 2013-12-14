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
    end
  end

  context "when spare" do
    pending "the player may throw one more ball" do

    end
  end

end

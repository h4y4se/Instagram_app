# frozen_string_literal: true

require "rails_helper"
require "support/utilities"

RSpec.describe "likes", type: :request do
  describe "#like" do
    let(:user){create(:user,:with_post)}

    context "未ログインの場合" do
      it "いいねボタンが表示されていないこと" do
        get root_path
        expect(response.body).not_to include ".like_button"
      end
      it "いいねができないこと" do
        expect do
          user
          post like_path(id: 1, post_id: 1), xhr: true, params: {post_id: 1, user_id: 1}
        end.to_not change(Like, :count)
      end
    end

    context "ログイン済みの場合" do
      before do
        log_in(user)
      end

      it "いいねしていない場合、いいねができること" do
        expect do
          post like_path(id: 1, post_id: 1), xhr: true, params: {post_id: 1, user_id: 1}
        end.to change(Like, :count).by(1)
      end
      it "いいねボタンを２回押した場合、いいねが１回できること" do
        expect do
          post like_path(id: 1, post_id: 1), xhr: true, params: {post_id: 1, user_id: 1}
          post like_path(id: 1, post_id: 1), xhr: true, params: {post_id: 1, user_id: 1}
        end.to change(Like, :count).by(1)
      end
    end
    describe "#unlike" do
      let(:user){create(:user,:with_post,:with_like)}
      it "いいねしていた場合、いいねの解除ができること" do
        log_in(user)
        expect do
          delete unlike_path(id: 1, post_id: 1), xhr: true, params: {post_id: 1, user_id: 1}
        end.to change(Like, :count).by(-1)
      end
    end
  end
end

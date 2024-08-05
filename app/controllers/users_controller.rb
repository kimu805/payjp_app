class UsersController < ApplicationController
  def show
    Payjp.api_key = ENV["PAYJP_SECRET_KEY"] # 環境変数を読み込む
    card = Card.find_by(user_id: current_user.id) # ユーザーのid情報を基に、カード情報を取得。

    redirect_to new_card_path and return unless card.present?

    customer = Payjp::Customer.retrieve(card.customer_token) # 先ほどのカード情報を基に、顧客情報を取得。
    @card = customer.cards.first # 顧客が複数カード登録している場合、最初のカード（first）情報を取得。
  end

  def update
    if current_user.update(user_params)
      redirect_to root_path, notice: "「#{current_user.name}」様の情報を編集しました。"
    else
      redirect_to action: "show"
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email)
  end
end

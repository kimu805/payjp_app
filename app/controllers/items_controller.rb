class ItemsController < ApplicationController
  before_action :find_item, only: :order #「find_item」を動かすアクションを限定
  def index
    @items = Item.all
  end

  def order
    redirect_to new_card_path and return unless current_user.card.present?
    # current_userに紐付くcardが存在（present）していなければ、カードの新規登録画面にリダイレクトして実行（return）する

    Payjp.api_key = ENV["PAYJP_SECRET_KEY"]
    customer_token = current_user.card.customer_token # ログインしているユーザーの顧客トークンを定義
    Payjp::Charge.create(
      amount: @item.price, # 商品の値段
      customer: customer_token, # 顧客のトークン
      currency: "jpy" # 通貨の種類（日本円）
    )
    ItemOrder.create(item_id: params[:id]) # 商品のid情報を「item_id」として保存する

    redirect_to root_path, notice: "商品「#{@item.name}」を購入しました。"
  end

  private
  def find_item
    @item = Item.find(params[:id])
  end
end

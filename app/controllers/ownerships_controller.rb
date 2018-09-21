class OwnershipsController < ApplicationController
  def create
    @item = Item.find_or_initialize_by(code: params[:item_code])

    unless @item.persisted?
      # @item が保存されていない場合、先に @item を保存する
      results = RakutenWebService::Ichiba::Item.search(itemCode: @item.code)

      @item = Item.new(read(results.first))
      @item.save
    end

    # Want 関係として保存
    if params[:type] == 'Want'
      current_user.want(@item)
      flash[:success] = '商品を Want しました。'
    end  
#have function追加      
    if params[:type] == 'have'
      current_user.have(@item)
      flash[:success] = '商品を Have しました。'
#have function追加

    end

    redirect_back(fallback_location: root_path)
  end

  def destroy
    @item = Item.find(params[:item_id])

    if params[:type] == 'Want'
      current_user.unwant(@item) 
      flash[:success] = '商品の Want を解除しました。'
    end

#unhave function追加
    if params[:type] == 'Have'
      current_user.unhave(@item) 
      flash[:success] = '商品の Have を解除しました。'
    end
#unhave function追加

    redirect_back(fallback_location: root_path)
  end
end
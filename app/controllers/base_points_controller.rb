class BasePointsController < ApplicationController
 
    def index
        @base_point  = BasePoint.new
        @base_points = BasePoint.all
    end
    
    # GET /base_points/1
    def show
    end
    
    # GET /base_points/new
    def new
        @base_point = BasePoint.new
    end
    
    # GET /base_points/1/edit
    def edit
    end

    def create
        @base_point = BasePoint.new(base_point_params)
        if @base_point.save
          flash[:success] = "拠点情報を登録しました"
        else
          flash[:error] = "拠点情報の登録に失敗しました"
        end
        redirect_to base_points_path
    end
    
    def update
        @base_point = BasePoint.find(params[:id])
        if @base_point.update(base_point_params)
          flash[:success] = "拠点の変更完了しました"
        else
          flash[:error] = "拠点の変更に失敗しました"
        end
        redirect_to base_points_path
    end
    
    def destroy
        if BasePoint.find(params[:id]).destroy
          flash[:success] = "拠点情報を削除しました"
        else
          flash[:error] = "拠点情報の削除に失敗しました"
        end
        redirect_to base_points_path
    end

    private
      def base_point_params
        params.require(:base_point).permit(:name, :attendance_state, :attendance_state0)
      end
end
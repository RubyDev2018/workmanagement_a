class BaseInfoController < ApplicationController
  def index
    @base_info = BaseInfo.new
    @bases_info = BasePoint.all
  end
end

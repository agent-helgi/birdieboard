module Golf
  class BaseController < ApplicationController
    before_action :authenticate_user!

    layout "golf"
  end
end

require 'will_paginate'
require 'will_paginate/active_record'

class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
end

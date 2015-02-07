# Application Controller provides global controller methods
# These can be accessed from any other controller
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private
  
  def convert_to_seconds(rec_of_element, property)
    minutes_duration = rec_of_element["#{property}(5i)"].to_i
    seconds_duration = rec_of_element["#{property}(6i)"].to_i
    (minutes_duration * 60) + seconds_duration
  end

  def get_array_total(rec_of_element, property)
    rec_of_element_array = []
    rec_of_element.each do |element|
      rec_of_element_array << element[property]
    end
    rec_of_element_array.inject { |a, e| a + e }
  end

  def set_archetype
    @archetype = Archetype.find(params[:id])
  end

  def archetype_params
    params.require(:archetype).permit(:name)
  end

  def admin?
    redirect_to(new_user_session_path,
                notice: 'Only authorized folks can acces this') unless
                                                              current_user.admin
  end
end

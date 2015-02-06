class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private
  def get_array_total(rec_of_element, property)
    rec_of_element_array = []
    total_of_element = ""
    rec_of_element.each do |element|
      rec_of_element_array << element[property]
    end
    total_of_elements = rec_of_element_array.inject{|sum,x| sum + x }
  end

  def set_archetype
    @archetype = Archetype.find(params[:id])
  end

  def archetype_params
    params.require(:archetype).permit(:name)
  end

  def is_admin?
    if !current_user.admin then
      redirect_to(new_user_session_path, :notice => 'Only authorized folks can acces this')
    end
  end

end

# Archetype Controller, handles the CRUD operation to the Archetype Model
# Each Archetype represents a character class in Diablo III
class ArchetypesController < ApplicationController
  before_action :admin?
  before_action :set_archetype, only: [:show, :edit, :update, :destroy]

  respond_to :html
  def index
    @archetypes = Archetype.all.order('name')
    respond_with(@archetypes)
  end

  def show
    respond_with(@archetype)
  end

  def new
    @archetype = Archetype.new
    respond_with(@archetype)
  end

  def edit
  end

  def create
    @archetype = Archetype.new(archetype_params)
    @archetype.save
    respond_with(@archetype)
  end

  def update
    @archetype.update(archetype_params)
    respond_with(@archetype)
  end

  def destroy
    @archetype.destroy
    respond_with(@archetype)
  end

  private
end

class MusicsController < ApplicationController
  before_action :set_music, only: [:update]

  def index
    @musics_grid = MusicsGrid.new(params[:musics_grid]) do |scope|
      scope.order(posted: :desc).page(params[:page])
    end
  end

  def update
    respond_to do |format|
      if @music.update(viewed: @music.viewed ? false : true)
        format.json { render nothing: true, status: :ok }
      end
    end
  end

  def parse
    ParserJob.perform_later(musics_params.to_h)
    redirect_back(fallback_location: root_path)
  end

  private

  def set_music
    @music = Music.find(params[:id])
  end

  def musics_params
    params.require(:musics).permit(:parse_url, :parse_pages)
  end
end

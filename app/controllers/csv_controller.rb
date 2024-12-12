class CsvController < ApplicationController
  def new
  end

  def create
    file = params[:file]
    if file
      errors = CsvImporter.import(file)
      
      if errors.any?
        flash[:alert] = "There were errors in your CSV file:\n#{errors.join("\n")}"
        # Redirect to the show page, but pass errors in the flash
        redirect_to show_csv_index_url
      else
        redirect_to show_csv_index_url, notice: "Data successfully imported to Firestore!"
      end
    else
      render :new, alert: "Please upload a CSV file."
    end
  end

  def progress
    # Return the current progress as a JSON response
    progress = Rails.cache.read('csv_import_progress') || 0
    render json: { progress: progress }
  end

  def show
    @materials = []
    begin
      firestore = $firestore
      materials_ref = firestore.collection('materials')
      materials_ref.get.each do |doc|
        Rails.logger.info("Firestore document: #{doc.data}") # Log each document's data
        @materials << doc.data
      end
    rescue StandardError => e
      flash[:alert] = "Error fetching data: #{e.message}"
      @materials = []
    end
  end
end

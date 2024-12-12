require 'csv'

class CsvImporter
  def self.import(file)
    total_rows = CSV.read(file.path, encoding: 'CP932').length - 1  # Exclude headers
    processed_rows = 0
    errors = []
    
    CSV.foreach(file.path, headers: true, encoding: 'CP932').with_index(1) do |row, line_number|
      missing_columns = []
      missing_columns << '品目名1' if row['品目名1'].to_s.strip.empty?
      missing_columns << '標準単位' if row['標準単位'].to_s.strip.empty?
      missing_columns << '標準単価' if row['標準単価'].to_s.strip.empty?

      if missing_columns.any?
        errors << "Line #{line_number}: Missing data in columns: #{missing_columns.join(', ')}"
      else
        data = {
          created_at: Time.now,
          created_by: "csv",
          material_name: row['品目名1'],
          standard_unit: row['標準単位'],
          standard_unit_cost: row['標準単価'],
          updated_at: Time.now,
          updated_by: "csv"
        }
        
        $firestore.collection('materials').add(data)
      end

      # Increment progress (out of total rows)
      processed_rows += 1
      # Store progress in a session (or any other storage method)
      Rails.cache.write('csv_import_progress', (processed_rows.to_f / total_rows * 100).to_i)
    end

    errors
  end
end

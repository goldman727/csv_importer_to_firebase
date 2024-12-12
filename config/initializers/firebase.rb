require "google/cloud/firestore"

# Set the path to your service account key
Google::Cloud::Firestore.configure do |config|
  config.project_id  = "csvfileupload-a44fc"
  config.credentials = "config/SERVICE_ACCOUNT_KEY.json"
end

# Instantiate the Firestore client
$firestore = Google::Cloud::Firestore.new

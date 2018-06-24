namespace :open_time do
  desc "open_timing to open_model"
  task :moving => :environment do
    ActiveRecord::Base.transaction do
      places = Place.all

      places.each do |place|
        open_timings = place.open_timing
        unless open_timings.empty?
          open_timings.each do |open_timing|
            open = place.opens.new
            open.time = open_timing.to_json
            open.save!
          end
        end
      end
    end
  end
end

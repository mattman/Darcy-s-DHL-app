class BatchImporter

  def self.csv
    @_csv_class ||= begin
      if RUBY_VERSION < '1.9'
        require 'faster_csv'
        FasterCSV
      else
        require 'csv'
        CSV
      end
    end
  end

  Error       = Class.new(StandardError)
  InvalidType = Class.new(Error)
  InvalidRow  = Class.new(Error)

  # Usage: BatchImporter.import!(type, path_to_tmpfile)
  def self.import!(type, file)
    path = file.respond_to?(:path) ? file.path : file.to_s
    return false unless File.readable?(path)
    instance = self.new(type, path)
    instance.process!
    true
  end

  def initialize(type, path)
    @type = type.to_sym
    @path = path.to_s
    raise InvalidType.new unless respond_to?(:"import_#{type}")
  end

  def process!
    m = method(:"import_#{@type}")
    ActiveRecord::Base.transaction do
      self.class.csv.foreach(@path) do |row|
        import_row row, m
      end
    end
  end

  def import_row(row, with = m)
    m.call(row) if m.present? 
  rescue ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid => e
    Rails.logger.warn "Unable to import row: #{e.message}"
    #raise InvalidRow.new
  end

  def import_package(row)
    customer = Customer.from_name(row[2], row[3])
    customer.packages.create!({
      :serial_number => row[0],
      :description   => row[1]
    })
  end

  def import_package_location(row)
    package = Package.from_serial_number(row[0])
    package.intransit_notices.create!({
      :tag_sequence => row[1].to_i,
      :status       => row[2],
      :recorded_at  => Time.parse(row[3]),
      :lat          => row[4].to_f,
      :lng          => row[5].to_f,
      :comment      => row[6]
    })
  end

  def import_customer(row)
    Customer.create!({
      :first_name => row[0],
      :last_name  => row[1],
      :address    => row[2]
    })
  end

  def import_carrier(row)
    Carrier.create!({
      :identifier => row[0],
      :name       => row[1],
      :address    => row[2],
      :password   => row[3]
    })
  end

end

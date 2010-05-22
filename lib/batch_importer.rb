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
  def self.import!(type, file, opts = {})
    path = file.respond_to?(:path) ? file.path : file.to_s
    return false unless File.readable?(path)
    begin
      instance = self.new(type, path, opts = {})
      instance.process!
      true
    rescue Error => e
      Rails.logger.debug "Exception: #{e.message}"
      false
    end
  end

  def initialize(type, path, opts = {})
    @type = type.to_sym
    @path = path.to_s
    @opts = {}
    raise InvalidType.new unless respond_to?(:"import_#{type}")
  end

  def process!
    Rails.logger.debug "Importing all for #{@type} - #{@path}"
    m = method(:"import_#{@type}")
    ActiveRecord::Base.transaction do
      self.class.csv.foreach(@path, :quote_char => "'") do |row|
        import_row row, m
      end
    end
  end

  protected

  def import_row(row, with = m)
    with.call(row) if with.present? 
  rescue ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid => e
    raise InvalidRow.new("Unable to import row: #{e.message}")
  end

  def import_package(row)
    p row
    raise Error.new if row.size != 4
    customer = Customer.from_name(row[3], row[2])
    package = customer.packages.build({
      :serial_number => row[0],
      :description   => row[1],
    })
    package.carrier = Carrier.find(@opts[:carrier_id]) if @opts[:carrier_id]
    package.save!
  end

  def import_package_location(row)
    raise Error.new if row.size != 7
    package = Package.from_serial_number(row[0]).first || raise(Error.new("Unknown package"))
    raise Error.new if @opts[:carrier_id] && package.carrier_id != @opts[:carrier_id]
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
    raise Error.new if row.size != 3
    Customer.create!({
      :first_name => row[1],
      :last_name  => row[0],
      :address    => row[2]
    })
  end

  def import_carrier(row)
    raise Error.new if row.size != 4
    Carrier.create!({
      :identifier => row[0],
      :name       => row[1],
      :address    => row[2],
      :password   => row[3]
    })
  end

end

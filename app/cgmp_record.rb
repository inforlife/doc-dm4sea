class CGMPRecord
  def initialize(file_name)
    @table = DBF::Table.new("#{ENV['CGMP_PATH']}/#{file_name}.DBF")
  end

  def last
    @table.find(:all).last
  end

  def first(args)
    @table.find(:first, args)
  end

  def where(args)
    @table.find(:all, args)
  end
end

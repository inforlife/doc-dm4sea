class BagCheck
  def self.call(cgmp_batch)
    /53-|56-/.match(cgmp_batch.codeprod).nil?
  end
end

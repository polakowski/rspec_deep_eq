class FakeRecord
  def initialize(value:)
    @value = value
  end

  def ==(another_record)
    if another_record.is_a?(FakeRecord)
      value == another_record.value
    end
  end

  def inspect
    "#<FakeRecord @value=#{value}>"
  end

  attr_reader :value
end

require "csv"
require "pp"
#Creating a Person Class to cleanly create entry and contain methods related
class Person
  #blatantly stole this email validating regex from stackoverflow
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  #class vairable array for future use within class for methods
  @@array = Array.new
  #establishing class variable for counting entries
  @@count = 0

  attr_accessor :email, :first_name, :last_name, :datetime
  #so
  def self.all_instances
    @@array
  end
  #initialize Person Object
  def initialize(email, first_name, last_name, datetime)
    @email = email
    @first_name = first_name
    @last_name = last_name
    @datetime = datetime
    #each initialization of a Person Object adds to the count
    self.class.count += 1
    #adds each instance of Person to an array for further manipulation
    @@array << self
  end

  def self.count
    @@count
  end

  def self.count=(value)
    @@count = value
  end
  #Parser reads csv file
  def self.csv_parser file_path
    #headers: true allows the parser to ignore the first header row of the csv file
    read_csv_file = CSV.read(file_path, headers:true)
    read_csv_file.each do |entry|
      #Person.new uses struct to set each entry as a new Person object
      Person.new(entry['email'], entry['first_name'], entry['last_name'], entry['datetime'])
    end
  end

  def self.emails_names
    self.all_instances.map {|e| e.email}
  end
  #this seemed like the simplest way to find the unique number of email addresses
  def self.number_of_unique_emails
    self.emails_names.uniq.size
  end

  def self.unique_email_addresses
    self.emails_names.uniq
  end

  def self.unique_valid_email_addresses
    valid = []

    self.unique_email_addresses.each do |a|
      if a.match(VALID_EMAIL_REGEX)
        valid.push(a)
      end
    end
    return valid
  end

  def self.descending_domains
    #array for split domains
    hey_array = []
    #iterate through unique_valid_email_addresses
    self.unique_valid_email_addresses.each do |d|
      hey_array.push(d.split("@").last.downcase)
    end
    counts = Hash.new 0
    hey_array.each do |domain|
      counts[domain] += 1
    end
    #sort_by sorts by ascending reverse reverses that
    return counts.sort_by { |k,v| v }.reverse
  end


  #creates collection of Person objects instead of having to remember to call it outside class
  self.csv_parser('sample_data.csv')
end

puts "Your program should output the following:"
puts ""
pp "The total number of records in the file: #{Person.count}"
puts ""
pp "The total number of unique email addresses: #{Person.number_of_unique_emails}"
puts ""
pp "The total number of valid email addresses in the file: #{Person.unique_valid_email_addresses.size}"
puts ""
puts "A list of record counts by domain, sorted in descending order. (counts should be based on unique and valid addresses)"
pp Person.descending_domains

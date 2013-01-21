##
# class to manage list of contacts
#
class Contacts

  ##
  # create a Contacts object from string of pipe delimited ("|") fields, one record per line
  # e.g. "Brandon Faloona|Seattle|WA|bfaloona@uw.edu\nBarack Obama|Washington|DC|president@wh.gov"
  #
  def initialize data
    @raw_entries = data.split("\n")
    # set @contacts to an array of contacts
    @contacts = @raw_entries.collect do |line|
      contact_hash line
    end
  end

  def raw_entries
    @raw_entries
  end

  ##
  # the list of fields expected in input lines
  #
  def fields
    [:full_name, :city, :state, :email]
  end

  ##
  # create a contact (a hash) from raw input line
  #
  def contact_hash line
    values = line.split("|")
    Hash[fields.zip values]
  end

  ##
  # return a comma separated list of formatted email addresses
  #
  def email_list
    @raw_entries.collect do |line|
      name, city, state, email = line.split("|")
      format_email_address name, email.chomp
    end.join(", ")
  end

  ##
  # returns "Display Name" <email@address> given name and email
  #
  def format_email_address name, email
    %{\"#{name}\" <#{email}>}
  end

  def num_entries
    @raw_entries.length
  end

  def contact index
    @contacts[index.to_i]
  end

  #########

  def format_contact contact
    %{"#{contact[:full_name]} of #{contact[:city]} #{contact[:state]}" <#{contact[:email]}>} 
  end

  def all
    @contacts
  end

  def formatted_list
    list = String.new
    @contacts[0..-2].each do |contact|
      list << format_contact(contact) << "\n"
    end
    list << format_contact(@contacts[-1])
  end

  def full_names
    contact_full_names = Array.new()
    @contacts.each do |contact|
      contact_full_names.push(contact[:full_name])
    end
    
    return contact_full_names
  end

  def cities
    unique_cities = Array.new()
    @contacts.each do |contact|
      unique_cities.push(contact[:city]) if (!unique_cities.include?(contact[:city])) 
    end
    
    return unique_cities
  end

  def append_contact contact
    @contacts << contact
  end

  def delete_contact index
    @contacts.delete_at(index)
  end

  def search string
    string_match = Array.new
    @contacts.each do |contact|
      contact.each do |key, value|
        if (value.eql?(string))
          string_match.push(contact)
          break
        end
      end
    end
    return string_match
  end

  def all_sorted_by field
    sorted = @contacts.sort_by { |key| key[field] }
    return sorted
  end
  
end

module PerspectiveSummary

  #HELPER METHODS
  def getMonthName(month_number)
    months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    months[month_number-1]
  end

  def last_six_months
    (Date.today.month-5..Date.today.month).to_a.join(", ")
  end

  def last_six_months_array
    (Date.today.month-5..Date.today.month)
  end

  def provider_kiosk_locations_id(provider)
    provider.kiosks.map(&:location_id).join(",")
  end
  def provider_pump_locations_id(provider)
    provider.pumps.map(&:location_id).join(",")
  end

  def sort_by_location_id(collection)
    collection.sort_by{|item| item.location_id.to_i}
  end

#*****************************CREDITS SOLD**************************
  #DASHBOARD
  def credits_sold_by_kiosk_by_month #Chart
    total_credits_by_kiosk_by_month = Transaction.select("location_id, sum(amount) as total,extract(month from transaction_time) as month").where("transaction_code in (20, 21) AND extract(month from transaction_time) IN (#{last_six_months})").group("extract(month from transaction_time),location_id")
    kiosk_location_array = total_credits_by_kiosk_by_month.map{ |obj| obj.location_id}.uniq.sort
    stacked_data = kiosk_location_array.map do |kiosk_id|
      transactions = total_credits_by_kiosk_by_month.select{|obj| obj.location_id == kiosk_id }
      values = last_six_months_array.map do |month|
        if transaction = transactions.find{|transaction| transaction.month == month}
          {x: getMonthName(month), y:transaction.total}
        else
          {x: getMonthName(month), y:0}
        end
      end
      {key: "Kiosk Location Id #{kiosk_id}", values: values}
    end
    data_to_display = {yAxisTitle: "Credits Sold (per Month, by Kiosk)", chartData:stacked_data, chartType: "stacked"};
  end
  #OPERATIONS and WATER KIOSKS
  def credits_sold_by_kiosk_table(table=true) #Table and Chart
    #Query for Bar Chart and Table
    kiosk_totals = Transaction.select("location_id, sum(amount) as total").where("transaction_code in (20,21)").group("location_id").order("sum(amount)")
    #Prepare data for Normalchart
    data = kiosk_totals.map do |obj|
      {label: obj.location_id.to_s, value: obj.total}
    end
    if table
      data
    else
      data_to_display = {yAxisTitle: "Credits Sold (per Kiosk)", xAxisLabel:"location id", chartData: [{values: data}], chartType: "bar"};
      return data_to_display
    end
  end

  #WATER KIOSKS
  # def credits_by_kiosk_for_all #Chart
  #   #Query for Bar Chart and Table
  #   kiosk_totals = Transaction.select("location_id, sum(amount) as total").where("transaction_code in (20,21)").group("location_id").order("sum(amount)")
  #   #Prepare data for Normalchart
  #   data = kiosk_totals.map do |obj|
  #     {label: obj.location_id.to_s, value: obj.total}
  #   end
  #   #Create json chart obj
  #   data_to_display = {yAxisTitle: "Water Credits Sold (per Kiosk)", xAxisLabel:"location id", chartData: [{values: data}], chartType: "bar"};
  # end

  #SPECIFIC PROVIDER PAGE
  def credits_sold_by_kiosk_for_provider(provider) #Chart
    return nil if provider.kiosks.empty?
    chart_data_array = []
    kiosk_total_obj_arr = Transaction.select("location_id, sum(amount) AS total").where("transaction_code IN (20,21) AND location_id IN (#{provider_kiosk_locations_id(provider)})").group("location_id").order("total")
    kiosk_total_obj_arr.each do |obj|
      chart_data_array.push({label: obj.location_id.to_s, value:obj.total})
    end
    data_to_display = {yAxisTitle:"Credits Sold per Kiosk (past five months)", xAxisLabel:"Location id", chartData:[{keys: "Credits sold", values: chart_data_array}], chartType:"bar"};
  end

  #SPECIFIC KIOSK PAGE
  def credits_sold_by_month(kiosk) #Chart
    sold_by_month = Transaction.select("sum(amount) as total,extract(month from transaction_time) as month").where("transaction_code IN (20,21) AND location_id = #{kiosk.location_id} AND extract(month from transaction_time) IN (#{last_six_months})").group("extract(month from transaction_time)")
    data = last_six_months_array.map do |month|
      if transaction = sold_by_month.find{|obj| obj.month == month }
        {label: getMonthName(month), value: transaction.total}
      else
        {label: getMonthName(month), value: 0}
      end
    end
    data_to_display = {yAxisTitle: "Credits Sold (per Month)", chartData:[{key:"Credits Sold (per Month)", values:data}], chartType: "bar"};
  end

#***********************************WATER DISPENSED***************************************
  #DASHBOARD
  def dispensed_by_pump_by_month #Stacked Bar Chart
    total_dispensed = Transaction.select("location_id, sum(amount) as total,extract(month from transaction_time) as month").where("transaction_code = 1 AND extract(month from transaction_time) IN (#{last_six_months})" ).group("extract(month from transaction_time),location_id")
    pump_location_array = total_dispensed.map{ |obj| obj.location_id}.uniq.sort
    stacked_data = pump_location_array.map do |pump_id|
      transactions = total_dispensed.select{|obj| obj.location_id == pump_id }
      values = last_six_months_array.map do |month|
        if transaction = transactions.find{|transaction| transaction.month == month}
          {x: getMonthName(month), y:transaction.total}
        else
          {x: getMonthName(month), y:0}
        end
      end
      {key: "Point Location Id #{pump_id}", values: values}
    end
    data_to_display = {yAxisTitle: "Liters Dispensed (per Month, by Point)", chartData:stacked_data, chartType: "stacked"};
  end

  #WATER PUMPS for chart and OPERATIONS for table
  def dispensed_by_pump_for_all_table(table=true) #Table and Chart
    pump_totals = Transaction.select("location_id, sum(amount) as total").where("transaction_code = 1").group("location_id").order("sum(amount)")
    data = sort_by_location_id(pump_totals).map do |obj|
      {label: obj.location_id.to_s, value: obj.total}
    end

    if table
      data
    else
      data_to_display = { yAxisTitle: "Liters Dispensed (per Point)", xAxisLabel: "Location ID", chartData: [{values:data}], chartType: "bar"};
    end
  end

  #SPECIFIC PROVIDER PAGE
  def dispensed_by_pump_for_provider(provider) #Chart
    return nil if provider.pumps.empty?
    #Query for Bar Chart and Table
    pump_total = Transaction.select("location_id, sum(amount) as total").where("transaction_code = 1 AND location_id in (#{provider_pump_locations_id(provider)}) AND extract(month from transaction_time) IN (#{last_six_months})").group("location_id").order("sum(amount)")
    data = pump_total.map do |transaction|
      {label: transaction.location_id.to_s, value: transaction.total}
    end
    #Create json chart obj
    data_to_display = {yAxisTitle:"Liters Dispensed (per Point)", xAxisLabel:"Location ID", chartData: [{key:"Liters Dispensed", values:data}], chartType:"bar"};
  end

  #SPECIFIC PUMP PAGE
  def dispensed_by_month(pump) #Chart
    #Query db
    dispensed_by_month = Transaction.select("sum(amount) as total,extract(month from transaction_time) as month").where("transaction_code = 1 AND location_id = #{pump.location_id} AND extract(month from transaction_time) IN (#{last_six_months})").group("extract(month from transaction_time)")
    #Prepare data
    data = last_six_months_array.map do |month|
      if transaction = dispensed_by_month.find{|obj| obj.month == month }
        {label: getMonthName(month), value: transaction.total}
      else
        {label: getMonthName(month), value: 0}
      end
    end
    #Create json chart obj
    data_to_display = { yAxisTitle: "Liters Dispensed (per Month)", chartData:[{key:"Liters Dispensed Per Month", values: data}], chartType: "bar"};
  end

#*********************************CREDITS BOUGHT & REMAINING************************
  #DASHBOARD and OPERATIONS
  def credits_bought_by_kiosk_table(table=true) #Table and Chart
    #Query db
    credits_init = Transaction.select("location_id, sum(amount) as total").where("transaction_code = 23").group("location_id")
    credits_other = Transaction.select("location_id, sum(amount) as total").where("transaction_code = 22 and ((starting_credits - ending_credits) < 0)").group("location_id")
    #Prepare data
    totals_hash = {}
    sort_by_location_id(credits_init).each do |obj|
      totals_hash[obj.location_id.to_s.to_sym] = obj.total
    end
    credits_other.each do |obj|
      totals_hash[obj.location_id.to_s.to_sym] += obj.total
    end
    data = totals_hash.map do |location_id,total|
      {label: location_id, value: total}
    end

    #Create json chart obj
    if table
      data
    else
      data_to_display = { xAxisLabel: "Kiosk Location ID", yAxisTitle: "Credits Bought (per Kiosk)", chartData:[{values:data}], chartType: "bar"};
    end
  end

  #DASHBOARD and OPERATIONS
  def credits_remaining_by_kiosk_table(table=true) #Table and Chart
    #Query db
    credits_init = Transaction.select("location_id, sum(amount) as total").where("transaction_code = 23").group("location_id")
    credits_subtract = Transaction.select("location_id, sum(amount) as total").where("transaction_code = 22 and ((starting_credits - ending_credits) > 0)").group("location_id")
    #Prepare data
    totals_hash = {}
    credits_init.sort_by(&:location_id).each do |obj|
      totals_hash[obj.location_id.to_s.to_sym] = obj.total
    end
    credits_subtract.each do |obj|
      totals_hash[obj.location_id.to_s.to_sym] -= obj.total
    end
    data = totals_hash.map do |location_id,total|
     {label: location_id, value: total}
    end
    #Create json chart obj
    if table
      data
    else
      data_to_display = { xAxisLabel: "Kiosk Location ID", yAxisTitle: "Credits Remaining (per Kiosk)", chartData:[{values:data}], chartType: "bar"};
    end
  end

  # def credits_remaining_by_kiosk_table
  #   #Query db
  #   credits_init = Transaction.select("location_id, sum(amount) as total, max(transaction_time) as date").where("transaction_code = 23").group("location_id")
  #   credits_subtract = Transaction.select("location_id, sum(amount) as total, max(transaction_time) as date").where("transaction_code = 22 and ((starting_credits - ending_credits) > 0)").group("location_id")
  #   #Prepare data
  #   chart_data_array = []
  #   totals_hash = {}
  #   date_hash = {}
  #   sort_by_location_id(credits_init).each do |obj|
  #     totals_hash[obj.location_id.to_s.to_sym] = obj.total
  #     date_hash[obj.location_id.to_s.to_sym] = obj.date.strftime('%b %d, %Y')
  #   end
  #   credits_subtract.each do |obj|
  #     totals_hash[obj.location_id.to_s.to_sym] -= obj.total
  #     if date_hash[obj.location_id.to_s.to_sym] < obj.date
  #       date_hash[obj.location_id.to_s.to_sym] = obj.date.strftime('%b %d, %Y')
  #     end
  #   end
  #   totals_hash.each {|location_id,total|
  #     chart_data_array.push({label: location_id, value: total, date: date_hash[location_id.to_s.to_sym]})
  #   }
  #   chart_data_array
  # end

  #DASHBOARD & OPERATIONS
  def sms_balance_by_pump_table(table=true)
    chart_data_array = []
    sms_balance_by_location = Transaction.select("location_id, transaction_time as date, sum(amount) as total").where("transaction_code=41").group("location_id,transaction_time").order("transaction_time DESC")
    existing_ids = []
    sms_balance_by_location.each do |obj|
      if !existing_ids.include?(obj.location_id)
      chart_data_array.push({location_id: obj.location_id, date: obj.date, total: obj.total})
        existing_ids.push(obj.location_id)
      else
        existing_ids.push(obj.location_id)
      end
    end

    if table
      return chart_data_array
    else
      data_to_display = { xAxisTitle: "Point Location ID", yAxisTitle: "SMS Remaining Credits (per Point)", chartData: chart_data_array, chartType: "bar", xKey:"kiosk" , yKey:"total"};
      return data_to_display
    end
  end


  # def sms_balance_by_pump_table
  #   chart_data_array = []
  #   sms_balance_by_location = Transaction.select("location_id, transaction_time as date, sum(amount) as total").where("transaction_code=41").group("location_id,transaction_time").order("transaction_time DESC")
  #   existing_ids = []
  #   sms_balance_by_location.each do |obj|
  #     if !existing_ids.include?(obj.location_id)
  #     chart_data_array.push({location_id: obj.location_id, date: obj.date.strftime('%b %d, %Y'), total: obj.total})
  #       existing_ids.push(obj.location_id)
  #     else
  #       existing_ids.push(obj.location_id)
  #     end
  #   end
  #   return chart_data_array
  # end

  def last_error_by_hub
    @gprs_errors_arr = []
    existing_ids = []
    gprs_errors = Transaction.select("location_id, transaction_time, count(amount) as count").where("transaction_code=39 AND amount =101 AND transaction_time > (Date.today - 30)").group("location_id").order("transaction_time")
    gprs_errors.each do |error|
      if !existing_ids.include?(obj.location_id)
        @gprs_errors_arr.push({location_id: error.location_id, error_type: "gprs", count: error.count})
      else
        existing_ids.push(errror.location_id)
      end
    end
    @bat_low_errors_arr = []
    bat_low_errors = Transaction.select("location_id, transaction_time, count(amount) as count").where("transaction_code=39 AND amount =132 AND transaction_time > (Date.today - 30)").group("location_id")
    bat_low_errors.each do |error|
      @bat_low_errors_arr.push({location_id: error.location_id, error_type: "bat_low" , count: error.count})
    end
  end

  def errors_by_hub_chart
    return nil if Transaction.all.empty?
    #Get array of all location ids
    location_ids = Transaction.all.map{|t| t.location_id}.uniq!

    #Query db for given error by location
    gprs_errors = Transaction.select("location_id, count(amount) as count").where("transaction_code=39 AND amount=101").group("location_id")
    rfid_errors = Transaction.select("location_id, count(amount) as count").where("transaction_code=39 AND amount =111").group("location_id")
    bat_low_errors = Transaction.select("location_id, count(amount) as count").where("transaction_code=39 AND amount =132").group("location_id")
    bat_ok_errors = Transaction.select("location_id, count(amount) as count").where("transaction_code=39 AND amount =133").group("location_id")

    errors_hash = {"GPRS Errors" => gprs_errors, "RFID Errors" => rfid_errors, "Battery Low" => bat_low_errors, "Battery OK" => bat_ok_errors}

    #Loop through all locations
    stacked_data = location_ids.map do |location_id|
      error_array = errors_hash.map do |name, errors|
        if error = errors.find {|object| object.location_id == location_id }
          {x: name, y: error.count}
        else
          {x:name, y:0}
        end
      end
      {key: "Location Id #{location_id}", values: error_array}
    end
    data_to_display = {yAxisTitle: "Errors by Hub", chartData:stacked_data, chartType: "stacked"};
  end

  def getHubs
    if admin_signed_in?
      kiosks = Kiosk.all
      pumps = Pump.all
    else
      kiosks = current_provider.kiosks
      pumps = current_provider.kiosks
    end
    {chartData: {kiosks: kiosks, pumps: pumps},
                  chartType: "map" }
  end

end

public with sharing class BookingCalendarController {

    public List<SelectOption> ModelPicklist {get; set;}
    public List<SelectOption> StatusPicklist {get; set;}
    public String selectedRego {get;set;}
    public Date selectedDate {get;set;}
    public List<Evaluation_Vehicle__c> evalVehicles {get;set;}
    public List<Date> dateRange {get;set;}
    public List<String> dateRangeString {get;set;}
    public List<BookingDatesWrapper> datesWrapper {get;set;}
    public List<BookingWrapper> bookingWrapper {get;set;}
    public Boolean showCalendar {get;set;}
    public Task taskDate {get;set;}
    
    public List<SelectOption> regions {get; set;}
    public List<SelectOption> selectedRegions {get; set;}
    public List<SelectOption> models {get; set;}
    public List<SelectOption> selectedModels {get; set;}
    public List<SelectOption> status {get; set;}
    public List<SelectOption> selectedStatus {get; set;}
    
    public BookingCalendarController(){
        taskDate = new Task();
        selectedRego = '';
        showCalendar = false;
        selectedDate = Date.Today();
        taskDate.ActivityDate = Date.Today();
        
        regions = new List<SelectOption>();
        selectedRegions = createRegionPicklist();
        models = new List<SelectOption>();
        selectedModels = createModelPicklist();
        status = new List<SelectOption>();
        selectedStatus = createStatusPicklist();
        
        evalVehicles = new List<Evaluation_Vehicle__c>();
        dateRange = new List<Date>();
        dateRangeString = new List<String>();
        datesWrapper = new List<BookingDatesWrapper>();
        bookingWrapper = new List<BookingWrapper>();
        setDateHeaders();
        showBookings();
    }
    
    public List<SelectOption> createRegionPicklist(){
        List<SelectOption> picklist = new List<SelectOption>();  
        Schema.DescribeFieldResult fieldResult = Evaluation_Vehicle__c.Region__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple){
           picklist.add(new SelectOption(f.getLabel(), f.getValue()));
        }   
        return picklist;     
    }
    
    public List<SelectOption> createModelPicklist(){
        List<SelectOption> picklist = new List<SelectOption>();  
        List<Product2> vehicles = [SELECT Id, Name, Model_Series__c FROM Product2 WHERE SFDC_Product_Level__c = 1];
        for(Product2 product : vehicles){
            String modelName = product.Model_Series__c+' - '+product.Name;
            picklist.add(new SelectOption(modelName, modelName));
        }   
        return picklist;     
    }
    
    public List<SelectOption> createStatusPicklist(){
        List<SelectOption> picklist = new List<SelectOption>();  
        Schema.DescribeFieldResult fieldResult = Evaluation_Vehicle__c.Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple){
            if(f.getLabel() != 'Grounded'){
                picklist.add(new SelectOption(f.getLabel(), f.getValue()));
            }
        }   
        return picklist;     
    }
    
    public String formatViewDate(Date viewDate){
        Integer monthDate = viewDate.month();
        Integer dayDate = viewDate.day();
        String monthString = '';
        String viewStringDate = '';
        if(monthdate == 1){
            monthString = 'Jan';
        }
        if(monthdate == 1){
            monthString = 'Jan';
        }
        if(monthdate == 2){
            monthString = 'Feb';
        }
        if(monthdate == 3){
            monthString = 'Mar';
        }
        if(monthdate == 4){
            monthString = 'Apr';
        }
        if(monthdate == 5){
            monthString = 'May';
        }
        if(monthdate == 6){
            monthString = 'Jun';
        }
        if(monthdate == 7){
            monthString = 'Jul';
        }
        if(monthdate == 8){
            monthString = 'Aug';
        }
        if(monthdate == 9){
            monthString = 'Sep';
        }
        if(monthdate == 10){
            monthString = 'Oct';
        }
        if(monthdate == 11){
            monthString = 'Nov';
        }
        if(monthdate == 12){
            monthString = 'Dec';
        }
        viewStringDate = String.valueOf(dayDate)+' - '+monthString;
        return viewStringDate;
    }
    
    public void setDateHeaders(){
        dateRangeString = new List<String>();
        dateRange = new List<Date>();
        datesWrapper = new List<BookingDatesWrapper>();
        selectedDate = taskDate.ActivityDate;
        Date viewStartDate = selectedDate - 14;
        for(integer i=0; i<56; i++){
            Boolean isWeekend = false;
            Boolean isCurrent = false;
            dateRange.add((viewStartDate+i));
            dateRangeString.add(formatViewDate((viewStartDate+i)));
            Integer dayOfWeek = dayOfWeek((viewStartDate+i));
            if(dayOfWeek == 5 || dayOfWeek == 6){
                isWeekend = true;
            }
            if((viewStartDate+i) == Date.Today()){
                isCurrent = true;
            }
            datesWrapper.add(new BookingDatesWrapper(formatViewDate((viewStartDate+i)), (viewStartDate+i), isWeekend, isCurrent));
        }
    }
    
    public static Integer dayOfWeek(Date d) {
           Date knownMonday = Date.newInstance(2009, 1, 12);
               Integer diff = Math.abs(knownMonday.daysBetween(d));
               return diff - (diff/7) * 7;
   }
    
    public void showBookings(){
        showCalendar = true;
        setDateHeaders();
        System.debug('##SELECTEDDATE: '+selectedDate);
        bookingWrapper = new List<BookingWrapper>();
        showSelectedRegion();
        
        Set<Id> evalVehiclesId = new Set<Id>();
        for(Evaluation_Vehicle__c eval : evalVehicles){
            evalVehiclesId.add(eval.Id);
        }
        
        
        List<Evaluation_Booking__c> evalBookings =[ Select Id, Start_Date__c, End_Date__c, Evaluation_Vehicle__c, Booking_Status__c, Contact__r.Name, Created_By_Name__c, Organisation__c from Evaluation_Booking__c where Evaluation_Vehicle__c IN :evalVehiclesId AND Booking_Status__c != 'Cancelled'];
        for(Evaluation_Vehicle__c eval : evalVehicles){
            BookingWrapper bwrap = new BookingWrapper();
            
            bwrap.evalVehicle = eval;
            
            for(integer i=0; i<56; i++){
                Date showStartDate = selectedDate.addDays(-14);
                String vacant = '0#'+showStartDate.addDays(i).format();
                bWrap.isBooked.set(i,vacant);
            }
            
            for(Evaluation_Booking__c eBooking : evalBookings){
                if(eval.Id == eBooking.Evaluation_Vehicle__c){
                    bWrap.evalBookings.add(eBooking);
                
                    for(integer i=0; i<56; i++){
                        //dateRange.add((viewStartDate+i));
                        Date showStartDate = selectedDate.addDays(-14);
                        if(((showStartDate.addDays(i)) >= eBooking.Start_Date__c) && ((showStartDate.addDays(i)) <= eBooking.End_Date__c)){
                            //String booked = '1#'+eBooking.Id;
                            String bookStatus = '1';
                            if(eBooking.Booking_Status__c == 'Pending Cancellation'){
                            	bookStatus = '2';
                            }
                            String booked = bookStatus+'#'+eBooking.Id+eBooking.Contact__r.Name+' - '+eBooking.Organisation__c+' - '+eBooking.Created_By_Name__c;
                            bWrap.isBooked.set(i,booked);
                        } else if(!bWrap.isBooked.get(i).startsWith('1')){
                            String vacant = '0#'+showStartDate.addDays(i).format();
                            bWrap.isBooked.set(i,vacant);
                        }
                    }
                }
            }
            
            bookingWrapper.add(bwrap);
            
        }
    }
    
    public class BookingDatesWrapper {
        
        public Date dateRange {get;set;}
        public String dateRangeString {get;set;}
        public Boolean isWeekend {get;set;}
        public Boolean isCurrentDate {get;set;}
        public String dateStyling {get;set;}
        
        public BookingDatesWrapper(String dateString, Date viewDate, boolean isWeekender, boolean isCurrent){
            dateRange = viewDate;
            dateRangeString = dateString;
            isWeekend = isWeekender;
            isCurrentDate = isCurrent;
            if(isCurrent == true){
                dateStyling = 'current';
            } else {
                if(isWeekender == true){
                    dateStyling = 'off';
                } else {
                    dateStyling = 'on';
                }
            }
        }
    }
    
    public class BookingWrapper {
        
        public Evaluation_Vehicle__c evalVehicle {get;set;}
        public List<Evaluation_Booking__c> evalBookings {get;set;}
        public List<String> isBooked {get;set;}
        
        public BookingWrapper(){
            evalBookings = new List<Evaluation_Booking__c>();
            isBooked = new List<String>();
            for(integer i=0;i<56;i++){
                isBooked.add(('0')); 
            }
        }
    }
    
    
    public void showSelectedRegion(){
        System.debug('&&SELECTEDREGIONs: '+selectedRegions);
        System.debug('&&SELECTEDMODELS: '+selectedModels);
        System.debug('&&SELECTEDSTATUS: '+selectedStatus);
        
        
        Set<String> regionsString = new Set<String>();
        Set<String> modelsString = new Set<String>();
        Set<String> statusString = new Set<String>();
        for(integer i = 0; i < selectedRegions.size();i++){
            regionsString.add(selectedRegions.get(i).getValue());
        }
        
        for(integer i = 0; i < selectedModels.size();i++){
            modelsString.add(selectedModels.get(i).getValue());
        }
        
        for(integer i = 0; i < selectedStatus.size();i++){
            statusString.add(selectedStatus.get(i).getValue());
        }
        
        String stringQuery = 'SELECT Status__c, SUO__c, Region__c, Model_Name__c, Id, Vehicle__r.Model_Series__c, ';
        stringQuery += 'Drive__c, Trans__c, Variant__c, Trans_Initials__c, Region_Initials__c, Colour__c, Name, Vehicle_Registration__c ';
        stringQuery += 'FROM Evaluation_Vehicle__c';
        
        if(regions.size() > 0){
            stringQuery += ' WHERE Region__c IN :regionsString';
        }
        
        if(models.size() > 0){
            if(regions.size() > 0){
                stringQuery += ' AND';
            }else {
                stringQuery += ' WHERE';
            }
            stringQuery += ' Model_Name__c IN :modelsString';
        }
        
        if(status.size() > 0){
            if(models.size() > 0 || regions.size() > 0){
                stringQuery += ' AND';
            }else {
                stringQuery += ' WHERE';
            }
            stringQuery += ' Status__c IN :statusString';
        } else {
            if(models.size() > 0 || regions.size() > 0){
                stringQuery += ' AND';
            }else {
                stringQuery += ' WHERE';
            }
            String grounded = 'Grounded';
            stringQuery += ' Status__c != :grounded';
        }
        
        if(selectedRego != ''){
            /*if(status.size() > 0 || models.size() > 0 || regions.size() > 0){
                stringQuery += ' AND';
            }else {
                stringQuery += ' WHERE';
            }*/
            stringQuery += ' AND Vehicle_Registration__c = :selectedRego';
        }
      
        System.debug('## '+stringQuery);
        
        evalVehicles = Database.query(stringQuery);
        System.debug('##DBASE '+evalVehicles);
    }
}
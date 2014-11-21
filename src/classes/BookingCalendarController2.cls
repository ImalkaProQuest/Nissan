public with sharing class BookingCalendarController2 {

    public List<SelectOption> ModelPicklist {get; set;}
    public List<SelectOption> StatusPicklist {get; set;}
    public String selectedRegion {get;set;}
    public String selectedModel {get;set;}
    public String selectedStatus {get;set;}
    public Date selectedDate {get;set;}
    public List<Evaluation_Vehicle__c> evalVehicles {get;set;}
    public List<Date> dateRange {get;set;}
    public List<String> dateRangeString {get;set;}
    public List<BookingDatesWrapper> datesWrapper {get;set;}
    public List<BookingWrapper> bookingWrapper {get;set;}
    public Boolean showCalendar {get;set;}
    public Task taskDate {get;set;}
    
    public List<string> leftRegionSelected{get;set;}
    public List<string> rightRegionSelected{get;set;}
    Set<string> leftRegionValues = new Set<string>();
    Set<string> rightRegionValues = new Set<string>();
    public List<string> leftModelSelected{get;set;}
    public List<string> rightModelSelected{get;set;}
    Set<string> leftModelValues = new Set<string>();
    Set<string> rightModelValues = new Set<string>();
    public List<string> leftStatusSelected{get;set;}
    public List<string> rightStatusSelected{get;set;}
    Set<string> leftStatusValues = new Set<string>();
    Set<string> rightStatusValues = new Set<string>();

    public BookingCalendarController2(){
        taskDate = new Task();
        selectedRegion = 'All';
        selectedModel = 'All';
        selectedStatus = 'All';
        showCalendar = false;
        selectedDate = Date.Today();
        taskDate.ActivityDate = Date.Today();
        
        leftRegionSelected = new List<String>();
        rightRegionSelected = new List<String>();
        rightRegionValues.addAll(createRegionSet());
        leftModelSelected = new List<String>();
        rightModelSelected = new List<String>();
        rightModelValues.addAll(createModelSet());
        leftStatusSelected = new List<String>();
        rightStatusSelected = new List<String>();
        rightStatusValues.addAll(createStatusSet());
        
        //ModelPicklist = createModelPicklist();
        StatusPicklist = createStatusPicklist();
        evalVehicles = new List<Evaluation_Vehicle__c>();
        dateRange = new List<Date>();
        dateRangeString = new List<String>();
        datesWrapper = new List<BookingDatesWrapper>();
        bookingWrapper = new List<BookingWrapper>();
        setDateHeaders();
        showBookings();
    }
    
    public Set<String> createRegionSet(){
        Set<String> regionValues = new Set<String>();
        Schema.DescribeFieldResult fieldResult = Evaluation_Vehicle__c.Region__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple){
          regionValues.add(f.getLabel());
        }   
        return regionValues;   
    }
    
    public Set<String> createModelSet(){
        Set<String> modelValues = new Set<String>();
        List<Product2> vehicles = [SELECT Id, Name, Model_Series__c FROM Product2 WHERE SFDC_Product_Level__c = 1];
        for(Product2 product : vehicles){
            String modelName = product.Model_Series__c+' - '+product.Name;
            modelValues.add(modelName);
        }   
        return modelValues;   
    }
    
    public Set<String> createStatusSet(){
        Set<String> statusValues = new Set<String>();
        Schema.DescribeFieldResult fieldResult = Evaluation_Vehicle__c.Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple){
            if(f.getLabel() != 'Grounded'){
                statusValues.add(f.getLabel());
            }
        }   
        return statusValues;   
    }    
    
    public List<SelectOption> createStatusPicklist(){
        List<SelectOption> picklist = new List<SelectOption>();
        picklist.add(new SelectOption('All','All'));
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
        if(selectedRegion == 'All'){
            evalVehicles = [
                                    SELECT 
                                        Status__c, 
                                        SUO__c, 
                                        Region__c, 
                                        Model_Name__c, 
                                        Id, 
                                        Vehicle__r.Model_Series__c,
                                        Drive__c,
                                        Trans__c, 
                                        Variant__c, 
                                        Trans_Initials__c, 
                                        Region_Initials__c, 
                                        Colour__c,
                                        Name
                                    FROM 
                                        Evaluation_Vehicle__c 
                                    WHERE
                                        Status__c != 'Grounded'
                            ];
        } else {
            evalVehicles = [
                                    SELECT 
                                        Status__c, 
                                        SUO__c, 
                                        Region__c, 
                                        Model_Name__c, 
                                        Id, 
                                        Vehicle__r.Model_Series__c, 
                                        Drive__c,
                                        Trans__c, 
                                        Variant__c, 
                                        Trans_Initials__c, 
                                        Region_Initials__c, 
                                        Colour__c,
                                        Name
                                    FROM 
                                        Evaluation_Vehicle__c 
                                    WHERE
                                        Region__c
                                    =
                                        :selectedRegion
                                    AND
                                        Status__c != 'Grounded'
                            ];
        }
        
        Set<Id> evalVehiclesId = new Set<Id>();
        for(Evaluation_Vehicle__c eval : evalVehicles){
            evalVehiclesId.add(eval.Id);
        }
        
        
        List<Evaluation_Booking__c> evalBookings =[ Select Id, Start_Date__c, End_Date__c, Evaluation_Vehicle__c, Contact__r.Name, Created_By_Name__c, Organisation__c from Evaluation_Booking__c where Evaluation_Vehicle__c IN :evalVehiclesId];
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
                            String booked = '1#'+eBooking.Id+eBooking.Contact__r.Name+' - '+eBooking.Organisation__c+' - '+eBooking.Created_By_Name__c;
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
    
    public PageReference selectRegionClick(){
        rightRegionSelected.clear();
        for(String s : leftRegionSelected){
            leftRegionValues.remove(s);
            rightRegionValues.add(s);
        }
        return null;
    }
     
    public PageReference unselectRegionClick(){
        leftRegionSelected.clear();
        for(String s : rightRegionSelected){
            rightRegionValues.remove(s);
            leftRegionValues.add(s);
        }
        return null;
    }
 
    public List<SelectOption> getunSelectedRegionValues(){
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(leftRegionValues);
        tempList.sort();
        for(string s : tempList)
            options.add(new SelectOption(s,s));
        return options;
    }
 
    public List<SelectOption> getSelectedRegionValues(){
        List<SelectOption> options1 = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(rightRegionValues);
        tempList.sort();
        for(String s : tempList)
            options1.add(new SelectOption(s,s));
        return options1;
    }
    
    public PageReference selectModelClick(){
        rightModelSelected.clear();
        for(String s : leftModelSelected){
            leftModelValues.remove(s);
            rightModelValues.add(s);
        }
        return null;
    }
     
    public PageReference unselectModelClick(){
        leftModelSelected.clear();
        for(String s : rightModelSelected){
            rightModelValues.remove(s);
            leftModelValues.add(s);
        }
        return null;
    }
 
    public List<SelectOption> getunSelectedModelValues(){
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(leftModelValues);
        tempList.sort();
        for(string s : tempList)
            options.add(new SelectOption(s,s));
        return options;
    }
 
    public List<SelectOption> getSelectedModelValues(){
        List<SelectOption> options1 = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(rightModelValues);
        tempList.sort();
        for(String s : tempList)
            options1.add(new SelectOption(s,s));
        return options1;
    }
    
    public PageReference selectStatusClick(){
        rightStatusSelected.clear();
        for(String s : leftStatusSelected){
            leftStatusValues.remove(s);
            rightStatusValues.add(s);
        }
        return null;
    }
     
    public PageReference unselectStatusClick(){
        leftStatusSelected.clear();
        for(String s : rightStatusSelected){
            rightStatusValues.remove(s);
            leftStatusValues.add(s);
        }
        return null;
    }
 
    public List<SelectOption> getunSelectedStatusValues(){
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(leftStatusValues);
        tempList.sort();
        for(string s : tempList)
            options.add(new SelectOption(s,s));
        return options;
    }
 
    public List<SelectOption> getSelectedStatusValues(){
        List<SelectOption> options1 = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(rightStatusValues);
        tempList.sort();
        for(String s : tempList)
            options1.add(new SelectOption(s,s));
        return options1;
    }
    
    public void showSelectedRegion(){
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,selectedRegion);
        ApexPages.addMessage(myMsg); 
        
        ApexPages.Message myMsg2 = new ApexPages.Message(ApexPages.Severity.ERROR,selectedModel);
        ApexPages.addMessage(myMsg2); 
    }
}
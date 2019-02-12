public class ProductManagementCtrl {
    
    public Integer directPage {get;set;}
    public Integer recordsTotal {get;set;}
    public Integer pagesTotal {get;set;}
    public Integer rulerSideCnt {get;set;}
    public String searchCriteria {get;set;}
    public Boolean showInputPanel {get;set;}
    public String  idToOperate {get;set;}
    public Product_Register__c startDate {get;set;}
    public Product_Register__c endDate {get;set;}
    public Product_Register__c newRecord {get;set;}
    //public List<Integer> indexesSet {get;set;}
    public List<Integer> leftIndSet {get;set;}
    public List<Integer> rightIndSet {get;set;}
    List<String> sortColumns; 
    Map<String,String> sortOrder;
    Integer pageSize = 10;
    Boolean applyDateInterval = false;
    String inputPanelMode = '';
    String toastType;
    Integer toastIndex = 1;
    String writeResult;
    string baseQueryString = 'SELECT Id, Name, Unit_Price__c, Units_Available__c, Product_Type__c, Arrival_Date__c, Production_Date__c, In_Stock__c  FROM Product_Register__c';
    
    public Integer getToastIndex(){
        return toastIndex;
    }
    public String getToastType(){
        return toastType;
    }
    public String getWriteResult(){
        return writeResult;
    }

    public void deleteRecord(){
        toastIndex = 3;
        for(Product_Register__c pr : (List<Product_Register__c>) setCtrl.getRecords()){
            if (pr.Id == idToOperate){
                try {
                    delete pr;
                    writeResult = 'was deleted succesfully.';
                    toastType = 'success';
                } catch (DmlException e) {
                    writeResult = 'was failed to delete.';
                    toastType = 'error';
                }
                break;
            }
        }
        showInputPanel = false;
        inputPanelMode = '';
        updateSet();
    }
    
    public void saveRecord(){
        toastIndex = 3;
        if (newRecord.Id == null)
            writeResult = 'was created succesfully.';
        else 
            writeResult = 'was updated succesfully.';
        toastType = 'success';
        try {
            if (newRecord.Id == null)
                insert newRecord;
            else
                update newRecord;
        } catch (DmlException e) {
            if (newRecord.Id == null)
                writeResult = 'failed to create.';
            else 
                writeResult = 'failed to update.';
            toastType = 'error';
            return;
        }
        
        showInputPanel = false;
        inputPanelMode = '';
        updateSet();
    }
    
    public String getInputPanelMode(){
        return inputPanelMode;
    }
    
    public void askForDeleteCurrentRecord(){
        toastIndex = 1;
        newRecord = new Product_Register__c();
        idToOperate = ApexPages.currentPage().getParameters().get('delId');
        for(Product_Register__c pr : (List<Product_Register__c>) setCtrl.getRecords()){
            if (pr.Id == idToOperate){
                newRecord.Id = idToOperate;
                newrecord.Name = pr.Name;
                break;
            }
        }
        inputPanelMode = 'delete';
        showInputPanel = true;
    }

    public void showCurrentRecord(){
        toastIndex = 1;
        newRecord = new Product_Register__c();
        idToOperate = ApexPages.currentPage().getParameters().get('showId');
        for(Product_Register__c pr : (List<Product_Register__c>) setCtrl.getRecords()){
            if (pr.Id == idToOperate){
                newRecord.Id = idToOperate;
                newrecord.Name = pr.Name;
                newrecord.Unit_Price__c = pr.Unit_Price__c;
                newrecord.Units_Available__c = pr.Units_Available__c;
                newrecord.Product_Type__c = pr.Product_Type__c;
                newrecord.Arrival_Date__c = pr.Arrival_Date__c;
                newrecord.Production_Date__c = pr.Production_Date__c;
                newrecord.In_Stock__c = pr.In_Stock__c;
                break;
            }
        }
        inputPanelMode = 'show';
        showInputPanel = true;
    }
    
    public void editCurrentRecord(){
        toastIndex = 1;
        newRecord = new Product_Register__c();
        for(Product_Register__c pr : (List<Product_Register__c>) setCtrl.getRecords()){
            if (pr.Id == idToOperate){
                newRecord.Id = idToOperate;
                newrecord.Name = pr.Name;
                newrecord.Unit_Price__c = pr.Unit_Price__c;
                newrecord.Units_Available__c = pr.Units_Available__c;
                newrecord.Product_Type__c = pr.Product_Type__c;
                newrecord.Arrival_Date__c = pr.Arrival_Date__c;
                newrecord.Production_Date__c = pr.Production_Date__c;
                break;
            }
        }
        inputPanelMode = 'edit';
        showInputPanel = true;
    }
    
    public void editNewRecord(){
        toastIndex = 1;
        newRecord = new Product_Register__c();
        newRecord.Arrival_Date__c = Date.today();
        inputPanelMode = 'new';
        showInputPanel = true;
    }
    
    public void applyDateFilter(){
        applyDateInterval = true;
        updateSet();
    }
    
    public void resetDateFilter(){
        applyDateInterval = false;
        updateSet();
    }
        
    public Integer getPageNumber(){
        return setCtrl.getPageNumber();
    }

    public Boolean getHasPrevious(){
        return setCtrl.getHasPrevious();
    }

    public Boolean getHasNext(){
        return setCtrl.getHasNext();
    }

    public void toPage(){
        if(directPage <= pagesTotal) setCtrl.setPageNumber(directPage);
    }
    
    public void prevPage(){
        if (setCtrl.getHasPrevious()) setCtrl.previous();
    }

    public void nextPage(){
        if (setCtrl.getHasNext()) setCtrl.next();
    }
    
    public String getNameOrder(){
        return sortOrder.get('Name');
    } 

    public String getPriceOrder(){
        return sortOrder.get('Unit_Price__c');
    } 

    public String getArrivalDateOrder(){
        return sortOrder.get('Arrival_Date__c');
    } 

    public String getAvailabilityOrder(){
        return sortOrder.get('In_Stock__c');
    } 
    
    public PageReference updatePageSize(){
        return null;
    }
    
    public PageReference updateSet(){
        setCtrl = null;
        return null;
    }

    void updateSortOrder(String col){
        If (sortColumns.indexOf(col) == -1){
            sortColumns.add(col);
            sortOrder.put(col,'ASC');
        } else {
            switch on sortOrder.get(col).length(){
                when 3 {sortOrder.put(col,'DESC');}
                when 4 {
                    sortOrder.put(col,'');
                    sortColumns.remove(sortColumns.indexOf(col));
                }
            }
        }
    }

    public PageReference flipNameOrder(){
        updateSortOrder('Name');
        return updateSet(); 
    }
    
    public PageReference flipPriceOrder(){
        updateSortOrder('Unit_Price__c');
        return updateSet();  
    }

    public PageReference flipArrivalDateOrder(){
        updateSortOrder('Arrival_Date__c');
        return updateSet();
    }
    
    public PageReference flipAvailabilityOrder(){
        updateSortOrder('In_Stock__c');
        return updateSet();
    }

    public String getNameStage(){
        if (sortColumns.indexOf('Name') == -1) return '';
        return String.valueOf(sortColumns.indexOf('Name')+1);
    }

    public String getPriceStage(){
        if (sortColumns.indexOf('Unit_Price__c') == -1) return '';
        return String.valueOf(sortColumns.indexOf('Unit_Price__c')+1);
    }

    public String getArrivalStage(){
        if (sortColumns.indexOf('Arrival_Date__c') == -1) return '';
        return String.valueOf(sortColumns.indexOf('Arrival_Date__c')+1);
    }

    public String getAvailabilityStage(){
        if (sortColumns.indexOf('In_Stock__c') == -1) return '';
        return String.valueOf(sortColumns.indexOf('In_Stock__c')+1);
    }

    public Integer getPageSize() {
        return pageSize;
    } 
    
    public void setPageSize(Integer pageSize) {
        directPage = (this.pageSize * (setCtrl.getPageNumber() - 1) + 1) / pageSize + 1;
        this.pageSize = pageSize; 
        setCtrl.setPageSize(pageSize);
        rebuildIndexes();
        toPage();
    }

    public List<Product_Register__c> pageSet {
        get{
            return (List<Product_Register__c>) setCtrl.getRecords();
        }
        set;
    }
    
    public ApexPages.StandardSetController setCtrl {
        get{
            if(setCtrl == null){
                String fullQueryString = baseQueryString;
                if (applyDateInterval || (searchCriteria != null && searchCriteria.length() != 0))
                    fullQueryString += ' WHERE ';
                if (searchCriteria != null && searchCriteria.length() != 0) 
                    fullQueryString += ' Name LIKE \'%' + searchCriteria + '%\'';
                if (applyDateInterval && searchCriteria != null && searchCriteria.length() != 0)
                    fullQueryString += ' AND ';
                if (applyDateInterval) {
                    fullQueryString += 'Arrival_Date__c >= ' +
                        String.valueOf(startDate.Arrival_Date__c.year()).leftPad(4,'0') + '-' +
                        String.valueOf(startDate.Arrival_Date__c.month()).leftPad(2,'0') + '-' + 
                        String.valueOf(startDate.Arrival_Date__c.day()).leftPad(2,'0') + 
                        ' AND Arrival_Date__c <= ' + 
                        String.valueOf(endDate.Arrival_Date__c.year()).leftPad(4,'0') + '-' +
                        String.valueOf(endDate.Arrival_Date__c.month()).leftPad(2,'0') + '-' + 
                        String.valueOf(endDate.Arrival_Date__c.day()).leftPad(2,'0'); 
                }
                if (sortColumns.size() != 0){
                    fullQueryString += ' ORDER BY ';  
                    for(integer i = 0; i < sortColumns.size(); i++){
                        fullQueryString += ((i > 0)?', ':'') + sortColumns.get(i) + ' ' + sortOrder.get(sortColumns.get(i));
                    }
                } 
                setCtrl = new ApexPages.StandardSetController(Database.getQueryLocator(fullQueryString));
                recordsTotal = setCtrl.getResultSize();
                setCtrl.setPageSize(pageSize);
                rebuildIndexes();
            }
            return setCtrl;
        }set;
    }
    
    void rebuildIndexes(){
        pagesTotal = recordsTotal / pageSize;
        pagesTotal += (Math.mod(recordsTotal, pageSize) != 0)?1:0;
        // hell knows why it doesn't simply allow this:
        // pagesTotal = recordsTotal / pageSize + (Math.mod(recordsTotal, pageSize) != 0)?1:0;
        leftIndSet = new List<Integer>();
        rightIndSet = new List<Integer>();
        rulerSideCnt = (pagesTotal/2 < 6)?(pagesTotal/2):5;
        if (pagesTotal>1){
            for (Integer i=1; i <= rulerSideCnt; i++){
                leftIndSet.add(i);  
                if (pagesTotal < 12) 
                    rightIndSet.add(pagesTotal-(pagesTotal/2 - i));
                else
                    rightIndSet.add(pagesTotal - (5 - i));
            } 
            if (pagesTotal < 12 && Math.mod(pagesTotal,2)==1) leftIndSet.add(leftIndSet.size()+1);
        }
    } 
    
    public ProductManagementCtrl(){
        startDate = new Product_Register__c();
        endDate = new Product_Register__c();
        newRecord = new Product_Register__c();
        sortColumns = new List<String>();
        sortOrder = new Map<String,String>();
        showInputPanel = false;
        directPage = 1;
    }
}
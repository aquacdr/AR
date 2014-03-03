public class ActionItemsController {
    
    public String repAcctNbr {get; set;}
    public Integer itemsToDisplay {get; set;}
    public User currUser {get; set;}
    public Market__c market {get; set;}
    public List<SObject> leadObjs {get; set;} 
    public List<ActionItem> coachActionItems,coachNCActionItems;
    public List<ActionItem> mngNbrActionItems,mngNbrNCActionItems;
    public List<ActionItem> mngPrsRepActionItems,mngPrsRepNCActionItems;
    private Map<String,ActionItem> allActionItems;
    public String userProfile {get; set;}
    public Boolean isOrderEnabled {get; private set;}
    public Boolean isSalesEnabled {get; private set;}
    public Boolean isBusinessEnabled {get; private set;}
    public Boolean displayMode {get; set;}
    public List<SObject> combObjLst {get; set;}
    public Market_Action_Items__c[] mkt_actionitem{get; set;}
    public String isSideBar {get; set;}
    public String cmpTxt {get; set;}
    
    public String getInitialize(){
        coachActionItems = new List<ActionItem>();
        mngNbrActionItems = new List<ActionItem>();
        mngPrsRepActionItems = new List<ActionItem>();
        coachNCActionItems = new List<ActionItem>();
        mngNbrNCActionItems = new List<ActionItem>();
        mngPrsRepNCActionItems = new List<ActionItem>();
        allActionItems = new Map<String,ActionItem>();
        List<Market_Action_Items__c> dwnLnBasedActions = new List<Market_Action_Items__c>();
        List<Market_Action_Items__c> smryBasedActions = new List<Market_Action_Items__c>();
        ActionItem dispItem;
            this.currUser = [select Id,LanguageLocaleKey,MRKT_ID__c,ACCT_NR__c,MRKT_ID_ACCT_NR_KEY__c,LDRSHP_TITL_LVL_NBR__c,Profile.Name
                             from User 
                             where Id=:UserInfo.getUserId()];
            this.userProfile = this.currUser.Profile.Name;
        if(this.market == null){
            this.market = [ Select  Market_Id__c,Name,Id,
                                    OPERTNL_CMPGN_CMPLTN_PCT__c,Enabled_Action_Item__c,Is_ALMPLUS_Enabled__c, Omniture_Suite_Name__c,
                                    CURRNT_CMPGN_RMN_DAY_CNT__c,ALM_Rep_Indicator__c, CMPGN_STRT_DT__c, CMPGN_NR__c, CMPGN_NR_NUMBER__c, 
                                    CMPGN_END_DT__c, NEXT_1_CMPGN_NR__c, LAST_UPDT_DT__c,GI3_Keep_Alive_URL__c,CURRENT_CAMPAIGN_NR__c , Mail_Plan_Enabled__c 
                                    From Market__c 
                            where   Market_Id__c=:currUser.MRKT_ID__c];
                        
        }
        //Added By Snehashis for Widget implementaion
        if(this.userProfile == null){
            this.userProfile = this.currUser.Profile.Name;
        }
        System.debug('^^^^^^^^^^^^^^^^^^^^^^ userProfile='+this.userProfile);
        if(this.market.Enabled_Action_Item__c!=null){
            for(String section:this.market.Enabled_Action_Item__c.split(';')){
                if(section=='Orders')
                    isOrderEnabled=true;
                if(section=='Sales')
                    isSalesEnabled=true;
                if(section=='Current Business')
                    isBusinessEnabled=true;
            }
        }
        
        ALMLogUtils.log('ActionItemController.getInitialize','market='+this.market);
        ALMLogUtils.log('ActionItemController.getInitialize','mkt_actionitem='+this.mkt_actionitem.size());
        if(this.userProfile =='Avon Leader')
        {
            for(Market_Action_Items__c item:mkt_actionitem)
            {
                system.debug('>>My AI Action_Item__r '+item.Id);
                system.debug('>>My AI Action_Item__r '+item.Action_Item__c);
                system.debug('>>My AI '+item.Action_Item__r.Category__c);
                System.debug(' >>Action_Item_Type__c '+item.Action_Item__r.Action_Item_Type__c);
                if(item.Action_Item__r.Action_Item_Type__c=='Downline'){
                    //snehashis added logic for Lead AI
                    if(item.Action_Item__r.Category__c=='New and In Progress Leads' && this.market.Is_ALMPLUS_Enabled__c){
                            dwnLnBasedActions.add(item);
                    }else if(item.Action_Item__r.Category__c!='New and In Progress Leads'){
                        dwnLnBasedActions.add(item);
                    }
                }
                if(item.Action_Item__r.Action_Item_Type__c=='Summary')
                {
                    if(item.Action_Item__r.Category__c=='New and In Progress Leads' && this.market.Is_ALMPLUS_Enabled__c){
                            smryBasedActions.add(item);
                    }else if(item.Action_Item__r.Category__c!='New and In Progress Leads'){
                            smryBasedActions.add(item);
                        }
                }
                String rptUrl=item.Filter_Param__c!=null?item.Report__r.Report_URL__c+'&'+item.Filter_Param__c:item.Report__r.Report_URL__c;
                
                //Another parameter is addedn with report url, on 17th Apr 2013
                rptUrl = rptUrl+'&pageName=Action_Items';
                
                dispItem=new ActionItem(item.Action_Item__r.Category__c,false,
                                        item.Default__c,item.Report__r.Report_Id__c,
                                        item.Report__r.Report_Type__c,this.market.Market_Id__c,rptUrl,item.Campaign__c);

                dispItem.Priority = item.Priority__c;
                
                if(item.Action_Item__r.Subject_Area__c=='Coaching Others'){
                    coachActionItems.add(dispItem);
                }
                if(item.Action_Item__r.Subject_Area__c=='Managing Numbers'){
                    if(item.Action_Item__r.Category__c=='New and In Progress Leads'){
                        if(this.market.Is_ALMPLUS_Enabled__c){
                            mngNbrActionItems.add(dispItem);
                        }
                    }else if(item.Action_Item__r.Category__c!='New and In Progress Leads'){
                        mngNbrActionItems.add(dispItem);
                    }
                }
                if(item.Action_Item__r.Subject_Area__c=='Managing Personal Reps'){
                        mngPrsRepActionItems.add(dispItem);
                }
                allActionItems.put(item.Action_Item__r.Subject_Area__c+':'+item.Action_Item__r.Category__c,dispItem);
            }
        }
        
        String critRepAcctNbr = this.repAcctNbr;
        //For Downline Base Action Items
        String actItemKey;
        SObject objToEval;
        Decimal fldVal;
        if(smryBasedActions.size()>0){
            /*if(this.leadObjs!=null)
                ALMLogUtils.log('ActionItemsController','>>>>>>>>>>>>Lead Object Size'+this.leadObjs.size());*/
            ALMLogUtils.log('ActionItemsController','>>>>>>>>>>>>All Aciton Items:'+this.allActionItems);
            if(this.combObjLst !=null){
                for(Market_Action_Items__c actItem : smryBasedActions){
                    ALMLogUtils.log('ActionItemsController','>>>>>Smry_Criteria_Fld__c='+actItem.Action_Item__r.Smry_Criteria_Fld__c);
                    ALMLogUtils.log('ActionItemsController','>>>>>Threshold__c='+actItem.Threshold__c);
                    //Changed by Snehashis for ALM+ Lead inclusion 7/27
                    actItemKey = actItem.Action_Item__r.Subject_Area__c+':'+actItem.Action_Item__r.Category__c;
                    if(actItemKey!='Managing Numbers:New and In Progress Leads'){
                        if(actItem.Action_Item__r.Smry_Criteria_Fld__c!=null){
                            //logic to run separately for MP and non MP Market
                            if(market.Mail_Plan_Enabled__c){
                                if(actItem.Campaign__c!=null){
                                    //run Action Item for other area
                                    if(actItem.Campaign__c.contains(cmpTxt)){
                                       ALMLogUtils.log('ActionItemsController','>>>>>Inside compare'+actItem.Campaign__c);
                                       fldVal = getFieldValue(this.combObjLst,actItem.Action_Item__r.Smry_Criteria_Fld__c,this.cmpTxt);
                                     }
                                }
                            }else{
                                fldVal = getFieldValue(this.combObjLst[0],actItem.Action_Item__r.Smry_Criteria_Fld__c);
                            }
                        }
                        dispItem = allActionItems.get(actItemKey);
                    }else{
                        Double dbl = 0.0;
                        /*if(this.leadObjs!=null){
                            dbl = this.leadObjs.size();
                        }*/
                        fldVal = Decimal.valueOf(dbl);
                        dispItem = allActionItems.get(actItemKey);
                    }
                    ALMLogUtils.log('ActionItemsController','>>>>>actItemKey                             = '+actItemKey);
                    ALMLogUtils.log('ActionItemsController','>>>>>fldVal                                 = '+fldVal);
                    ALMLogUtils.log('ActionItemsController','>>>>>Threshold__c                           = '+actItem.Threshold__c);
                    ALMLogUtils.log('ActionItemsController','>>>>>market.OPERTNL_CMPGN_CMPLTN_PCT__c     = '+this.market.OPERTNL_CMPGN_CMPLTN_PCT__c);
                    ALMLogUtils.log('ActionItemsController','>>>>>actItem.Campaign_Stage__c              = '+actItem.Campaign_Stage__c);
                    if(!actItem.Default__c){
                        ALMLogUtils.log('ActionItemsController','>>>>>dispItem = '+dispItem);
                        if(fldVal >= actItem.Threshold__c && this.market.OPERTNL_CMPGN_CMPLTN_PCT__c >= actItem.Campaign_Stage__c){
                            dispItem.IsDisplayed = true;
                        }
                    }
                    dispItem.setRecCountCnt(fldVal);
                    if(isSideBar!='4' && market.Mail_Plan_Enabled__c){
                        if(cmpTxt =='Current')
                            dispItem.reportUrl+='&campaignId='+market.CMPGN_NR__c;
                        if(cmpTxt =='Next')
                            dispItem.reportUrl+='&campaignId='+market.NEXT_1_CMPGN_NR__c;
                    }
                    if(isSideBar=='4'){
                        if(cmpTxt =='Current')
                            dispItem.reportUrl+='&campaignId='+market.CMPGN_NR__c;
                        if(cmpTxt =='Next'){
                            dispItem.reportUrl+='&campaignId='+market.NEXT_1_CMPGN_NR__c;
                            if(actItem.Action_Item__r.Subject_Area__c=='Coaching Others')
                                coachNCActionItems.add(dispItem);
                            if(actItem.Action_Item__r.Subject_Area__c=='Managing Numbers')
                                mngNbrNCActionItems.add(dispItem);
                            if(actItem.Action_Item__r.Subject_Area__c=='Managing Personal Reps')
                                mngPrsRepNCActionItems.add(dispItem);
                        }
                    }                       
                    ALMLogUtils.log('ActionItemsController','>>>>>>>>>>>>>>>>>> Action Item:'+dispItem);
                }
            }
        }
        
        /*
            For Markets that don't have mail plans the downline based
            action items are same as summary action items. 
        */
        ALMLogUtils.log('ActionItemsController','>>>>>>>> dwnLnBasedActions.size()='+dwnLnBasedActions.size());
        ALMLogUtils.log('ActionItemsController','>>>>>>>> this.combObjLst='+this.combObjLst.size());
        if(this.userProfile == 'Avon Leader'){
            if(this.combObjLst !=null){
                for(Market_Action_Items__c actItem : dwnLnBasedActions){
                    ALMLogUtils.log('ActionItemsController','>>>>>Smry_Criteria_Fld__c='+actItem.Action_Item__r.Smry_Criteria_Fld__c);
                    ALMLogUtils.log('ActionItemsController','>>>>>Threshold__c='+actItem.Threshold__c);
                    //Changed by Snehashis for ALM+ Lead inclusion 7/27
                    actItemKey = actItem.Action_Item__r.Subject_Area__c+':'+actItem.Action_Item__r.Category__c;
                    if(actItemKey!='Managing Numbers:New and In Progress Leads'){
                        if(actItem.Action_Item__r.Smry_Criteria_Fld__c!=null){
                            //logic to run separately for MP and non MP Market
                            if(market.Mail_Plan_Enabled__c){
                                ALMLogUtils.log('ActionItemsController','>>>>>cmpTxt received='+cmpTxt);
                                if(actItem.Campaign__c!=null){
                                        //run Action Item for other area
                                        if(actItem.Campaign__c.contains(cmpTxt)){
                                            ALMLogUtils.log('ActionItemsController','>>>>>Inside compare'+actItem.Campaign__c);
                                            fldVal = getFieldValue(this.combObjLst,actItem.Action_Item__r.Smry_Criteria_Fld__c,this.cmpTxt);
                                        }
                                }
                            }else{
                                fldVal = getFieldValue(this.combObjLst[0],actItem.Action_Item__r.Smry_Criteria_Fld__c);
                            }
                        }
                        dispItem = allActionItems.get(actItemKey);
                    }else{
                        Double dbl = 0.0;
                        /*if(this.leadObjs!=null){
                            dbl = this.leadObjs.size();
                        }*/
                        fldVal = Decimal.valueOf(dbl);
                        dispItem = allActionItems.get(actItemKey);
                    }
                    ALMLogUtils.log('ActionItemsController','>>>>>actItemKey                             = '+actItemKey);
                    ALMLogUtils.log('ActionItemsController','>>>>>fldVal                                 = '+fldVal);
                    ALMLogUtils.log('ActionItemsController','>>>>>Threshold__c                           = '+actItem.Threshold__c);
                    ALMLogUtils.log('ActionItemsController','>>>>>market.OPERTNL_CMPGN_CMPLTN_PCT__c     = '+this.market.OPERTNL_CMPGN_CMPLTN_PCT__c);
                    ALMLogUtils.log('ActionItemsController','>>>>>actItem.Campaign_Stage__c              = '+actItem.Campaign_Stage__c);
                    if(!actItem.Default__c){
    //                          actItemKey = actItem.Action_Item__r.Subject_Area__c+':'+actItem.Action_Item__r.Category__c;
                        
                        ALMLogUtils.log('ActionItemsController','>>>>>dispItem = '+dispItem);
                        ALMLogUtils.log('ActionItemsController','>>>>>fldVal                                 = '+fldVal);
                        ALMLogUtils.log('ActionItemsController','>>>>>Threshold__c                           = '+actItem.Threshold__c);
                        ALMLogUtils.log('ActionItemsController','>>>>>market.OPERTNL_CMPGN_CMPLTN_PCT__c     = '+this.market.OPERTNL_CMPGN_CMPLTN_PCT__c);
                        System.debug('isdisplayed --> '+dispItem.aicategory+' >>> '+(fldVal >= actItem.Threshold__c)+' -- '+(this.market.OPERTNL_CMPGN_CMPLTN_PCT__c >= actItem.Campaign_Stage__c)+' *** '+(fldVal >= actItem.Threshold__c && this.market.OPERTNL_CMPGN_CMPLTN_PCT__c >= actItem.Campaign_Stage__c));
                        if(fldVal >= actItem.Threshold__c && this.market.OPERTNL_CMPGN_CMPLTN_PCT__c >= actItem.Campaign_Stage__c){
                            dispItem.IsDisplayed = true;
                        }
                    }
                    if(actItem.Action_Item__r.Datatype__c=='Currency'){
                        dispItem.setRecCountAmt(fldVal);
                    }else{
                        dispItem.setRecCountCnt(fldVal);                        
                    }
                    if(isSideBar!='4' && market.Mail_Plan_Enabled__c){
                        if(cmpTxt =='Current')
                            dispItem.reportUrl+='&campaignId='+market.CMPGN_NR__c;
                        if(cmpTxt =='Next')
                            dispItem.reportUrl+='&campaignId='+market.NEXT_1_CMPGN_NR__c;
                    }
                    if(isSideBar=='4'){
                        if(cmpTxt =='Current')
                            dispItem.reportUrl+='&campaignId='+market.CMPGN_NR__c;
                        if(cmpTxt =='Next'){
                            dispItem.reportUrl+='&campaignId='+market.NEXT_1_CMPGN_NR__c;
                            if(actItem.Action_Item__r.Subject_Area__c=='Coaching Others')
                                coachNCActionItems.add(dispItem);
                            if(actItem.Action_Item__r.Subject_Area__c=='Managing Numbers')
                                mngNbrNCActionItems.add(dispItem);
                            if(actItem.Action_Item__r.Subject_Area__c=='Managing Personal Reps')
                                mngPrsRepNCActionItems.add(dispItem);
                        }
                    } 
                }
            }
        }
        return '';  
    }
    
    private Decimal getFieldValue(Sobject currRec,String colFlds){
        Decimal totVal = 0.0;
        System.debug('>>>>>>>>>>>>>>> colFlds'+colFlds);
        String tempFld;
        if(colFlds!=null){
            for(String fldName: colFlds.split('\n')){
                tempFld = fldName.trim();
                try{
                    totVal+=(currRec.get(tempFld)!=null?(Decimal)currRec.get(tempFld):0.0);
                }catch(Exception ex){
                    system.debug('Error on fetching value :-> '+ex);
                }
            }
        }
        return totVal;
    }
    
    //New methods added by Snehashis on 7/22
    
    private Decimal getFieldValue(List<SObject> objLst, String colFlds,String cmpTxt){
        system.debug('cmpTxt received :-> '+cmpTxt);
        Decimal totVal = 0.0;
        for(SObject obj:objLst){
            //if(cmpTxt=='Current' && market.CMPGN_NR__c==obj.get('OPERTNL_CMPGN_NR__c')){
            if(cmpTxt=='Current' && market.CMPGN_NR__c==String.valueOf(obj.get('FLD_SLS_CMPGN_NR__c'))){
                system.debug('Inside Loop CC :-> '+obj.get('FLD_SLS_CMPGN_NR__c')+'>>'+obj.get('OPERTNL_CMPGN_NR__c'));
                    totVal=getFieldValue(obj,colFlds);
                     system.debug('Total Value in GetFieldValue in CC:-> '+totVal);
                    break;
            }
             //if(cmpTxt=='Next' && market.NEXT_1_CMPGN_NR__c==obj.get('OPERTNL_CMPGN_NR__c')){
             if(cmpTxt=='Next' && market.NEXT_1_CMPGN_NR__c==String.valueOf(obj.get('FLD_SLS_CMPGN_NR__c'))){
                system.debug('Inside Loop NC :-> '+obj.get('FLD_SLS_CMPGN_NR__c'));
                    totVal=getFieldValue(obj,colFlds);
                     system.debug('Total Value in GetFieldValue in NC:-> '+totVal);
                    break;
            }
        }
            return totVal;
    }
    
    public void getCCCmpgnActionItems(){
        this.cmpTxt='Current';
        ALMLogUtils.log('ActionItemController','Current Campaign RESET ACTION ITEM:'+this.cmpTxt+'><'+this.coachActionItems+';;'+this.mngNbrActionItems+'<>'+this.mngPrsRepActionItems);
        getInitialize();
      }
    
    public void getNCCmpgnActionItems(){
        this.cmpTxt='Next';
        ALMLogUtils.log('ActionItemController','Next Campaign RESET ACTION ITEM:'+this.cmpTxt+'><'+this.coachActionItems+';;'+this.mngNbrActionItems+'<>'+this.mngPrsRepActionItems);
        getInitialize();
      }
    
    public List<ActionItem> getcoachActionItems(){
        ALMLogUtils.log('ActionItemController','ORDER ACTION ITEMS ALL:');
        System.debug('>>>>>>>>>>>>>>'+this.coachActionItems);
        return getTopActionItems(this.coachActionItems);
    }
    
    public List<ActionItem> getcoachNCActionItems(){
        ALMLogUtils.log('ActionItemController','Next Campaign ORDER ACTION ITEMS ALL:');
        System.debug('>>>>>>>>>>>>>>'+this.coachNCActionItems);
        return getTopActionItems(this.coachNCActionItems);
    }
    
    public List<ActionItem> getmngNbrActionItems(){
        ALMLogUtils.log('ActionItemController','SALES ACTION ITEMS ALL:');
        System.debug('>>>>>>>>>>>>>>'+this.mngNbrActionItems);
        return getTopActionItems(this.mngNbrActionItems);
    }
    
    public List<ActionItem> getmngNbrNCActionItems(){
        ALMLogUtils.log('ActionItemController','Next Campaign SALES ACTION ITEMS ALL:');
        System.debug('>>>>>>>>>>>>>>'+this.mngNbrNCActionItems);
        return getTopActionItems(this.mngNbrNCActionItems);
    }
    public List<ActionItem> getmngPrsRepActionItems(){
        ALMLogUtils.log('ActionItemController','C-BUSINESS ACTION ITEMS ALL:');
        System.debug('>>>>>>>>>>>>>>'+this.mngPrsRepActionItems);
        return getTopActionItems(this.mngPrsRepActionItems);
    }
    public List<ActionItem> getmngPrsRepNCActionItems(){
        ALMLogUtils.log('ActionItemController','Next Campaign C-BUSINESS ACTION ITEMS ALL:');
        System.debug('>>>>>>>>>>>>>>'+this.mngPrsRepNCActionItems);
        return getTopActionItems(this.mngPrsRepNCActionItems);
    }
    private List<ActionItem> getTopActionItems(List<ActionItem> actItemList){

        List<ActionItem> tempList = new List<ActionItem>();
        Integer nbrItemsDisplayed = 0;
        if(actItemList != null){
            for(ActionItem item:actItemList){
                if(tempList.size()==this.itemsToDisplay){
                    break;
                }else if(item.IsDisplayed && !item.IsDefault){
                    ALMLogUtils.log('ActionItemsController.getTopActionItems','adding Action Item:'+item+' to Display List');
                    tempList.add(item);
                }       
            }   
        }
        ALMLogUtils.log('ActionItemController','Temp List after adding Displayed Action Items:'+tempList);
        if(tempList.size()<this.itemsToDisplay){
            if(actItemList != null){
                for(ActionItem item:actItemList){
                    if(tempList.size()==this.itemsToDisplay){
                        break;
                    }else if(item.IsDefault){
                        ALMLogUtils.log('ActionItemsController.getTopActionItems','adding Action Item:'+item+' to Display List');
                        tempList.add(item);
                    }       
                }
            }   
        }
        //adding logic to determine last item.
        if(tempList!=null && tempList.size()>1)
            tempList[1].oddRow=true;
        ALMLogUtils.log('ActionItemController','Temp List after adding default Action Items:'+tempList);
        return tempList;
    } 
}
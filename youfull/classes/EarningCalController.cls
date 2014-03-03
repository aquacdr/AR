/*
    *  This class is used to represent
    *  the business requirements of Leadership
    *  Earning Illustrator in AVON YOU.
    *
    *  Created on 12 Mar, 2012
    *  Created by Raktim Sarkar
    *
    *  Modified - constructor and method getData on 16 Mar, 2012
    *  Modified by Raktim Sarkar
    *
    *
**/

global without sharing class EarningCalController 
{
    public User currUsr {get; set;}
    public Market__c market {get; set;}
    public List<Leader_Title__c> lst_EstimtdErng {get; set;}
    public List<String> lst_EstimtdErngLevel {get; set;}
    public List<String> lst_TitleDesc {get; set;}
    public String userLangCd {get; set;} 
    public String rowDisplayed {get; set;}
    public String newRepDisplayed {get; set;}
    public String newRepPic {get; set;}
    public Integer totalEstimtdErng {get;set;}
    public Integer totalEstimtdErngDisplyd {get;set;}
    
    global static String marketLeaderTitleNumbr;
    global static Map<Integer, String> mapEstimtdErng;  
    global static Map<Integer, String> mapTitlLvl; 
    public ALM_Global_Settings__c globalConfig {get; set;}
    public String repDetailAcctNbr {get; set;}
    
    global static PageReference errPage {get; set;}
    
    global static String videoUrl {get; set;}
    global static String videoType {get; set;}
    global static String imageUrl {get; set;}
    global static eTools_Widget__c eTlWdgt {get; set;}
    
    // Constructor - START
    public EarningCalController()
    {  
        totalEstimtdErng = 0;
        totalEstimtdErngDisplyd = 0;
        lst_EstimtdErngLevel = new List<String>();
        lst_TitleDesc = new List<String>();
                
    } // End of Constructor
    
    
    // Method to execute for gathering base informations
    // required to display in page
    public PageReference loadData()
    {
        String marktLdrLevelNum;
                
        try{
            
        this.globalConfig = ALMPlusUtils.fetchALMGlobalSetting();   
        
        rowDisplayed = '<table width="100%" border="0" cellspacing="0" cellpadding="0" class="ear_tab"><tr><td class="lft">'+System.Label.ErngIllustrator_PersnVol+':</td>';
         rowDisplayed += '<td class="rht">'+System.Label.ErngIllustratr_NewRep_ZeroVal+'</td></td></tr>';
           rowDisplayed +='<tr class="bg_gry_tbl" >';
              rowDisplayed +='<td class="lft">'+System.Label.ErngIllustratr_TotUnitSl+':</td>';
                 rowDisplayed +='<td class="rht">'+System.Label.ErngIllustratr_NewRep_ZeroVal+'</td></tr>';
                      rowDisplayed +='<tr><td class="lft">'+System.Label.ErngIllustratr_G1ActiveReps+':</td><td class="rht">0</td></tr>';
                      
        System.Debug('\n EarningCalController loadData -1 ');
        // Retrieving current user information
        currUsr     =   [SELECT MRKT_ID__c, LanguageLocaleKey ,MRKT_ID_ACCT_NR_KEY__c, Profile.Name, LDRSHP_TITL_LVL_NBR__c
                         FROM   User
                         WHERE  Id = :UserInfo.getUserId()
                        ];
        System.Debug('\n EarningCalController loadData -2 MRKT ID from User  -> '+currUsr.MRKT_ID__c);
        
        // Setting the current user's language code
        userLangCd = currUsr.LanguageLocaleKey;
        System.Debug('\n EarningCalController loadData -3 LanguageLocaleKey from User -> '+userLangCd);
        
        // Retrieving market information based upon current user's Market Id
        market      =   [select ID, Market_Id__c,Omniture_Suite_Name__c, Max_Ldr_Titl_LVL__c, EARN_ILLT_VIDEO_LNK_TYP__c 
                         from Market__c WHERE Market_Id__c=:currUsr.MRKT_ID__c]; 
        
        marktLdrLevelNum    = String.valueOf(market.Max_Ldr_Titl_LVL__c);
        
        System.Debug('\n EarningCalController loadData EARN_ILLT_VIDEO_LNK_TYP__c -> '+market.EARN_ILLT_VIDEO_LNK_TYP__c);
        
        if(market.EARN_ILLT_VIDEO_LNK_TYP__c != null &&  !market.EARN_ILLT_VIDEO_LNK_TYP__c.trim().equals(''))
        {
            eTlWdgt = [Select Id, Image_URL__c, Position__c, URL_to_Open__c, Type__c 
                       FROM eTools_Widget__c WHERE Market__c=:market.ID AND 
                       Type__c=:market.EARN_ILLT_VIDEO_LNK_TYP__c AND  
                       Module_Type__c=:ALMConstants.REPORT_TYPE_ERNG_ILLUSTRATR LIMIT 1];
            System.Debug('\n EarningCalController loadData eTools_Widget__c -> \n'+eTlWdgt);
            if(eTlWdgt != null){
                videoUrl = eTlWdgt.URL_to_Open__c;
                videoType = eTlWdgt.Type__c;    
                imageUrl = eTlWdgt.Image_URL__c;
            }else{
                System.Debug('\n NO DATA in eTOOLWIDGET FOUND For Market Earning Illustr' +
                             'Video Indctr :: '+market.EARN_ILLT_VIDEO_LNK_TYP__c+'. Now Setting Default ..');
                videoUrl = System.Label.ErngIllustratr_Default_VideoURL;
                videoType = System.Label.ErngIllustratr_Default_VideoTyp;   
                imageUrl = '';  
            }
        }else{
            System.Debug('\n NO INDICATOR SET in MARKET FOR EARNING ILLUSTRATOR VIDEO LINK. Now Setting Default ..');
            videoUrl = System.Label.ErngIllustratr_Default_VideoURL;
            videoType = System.Label.ErngIllustratr_Default_VideoTyp;   
            imageUrl = '';
            
        }
         
        System.Debug('\n EarningCalController loadData -5 marktLdrLevelNum from Market -> '+marktLdrLevelNum);
        System.Debug('\n EarningCalController loadData -6 MRKT ID from Market  -> '+market.Market_Id__c);
        
        // Retrieving available estimated earning values except 'Candidate' from Leader Title
        // based upon current user's Market Id, language code 
        lst_EstimtdErng  =  [SELECT MIN_EST_ERNGs_AMT__c FROM Leader_Title__c 
                             WHERE  Market__r.Market_Id__c=:market.Market_Id__c
                             AND    LANG_CD__c=:userLangCd
                             AND    LCL_LDRSHP_TITL_LANG_DESC_TXT__c NOT IN ('Candidate')
                             AND    LDRSHP_TITL_LVL_NR__c > '0'
                             AND    LDRSHP_TITL_LVL_NR__c != '-2'
                             AND    LDRSHP_TITL_LVL_NR__c <=:marktLdrLevelNum
                             ORDER BY LDRSHP_TITL_LVL_NR__c DESC]; // MIN_EST_ERNGs_AMT__c is replaced - 6th Sept 2013 by Raktim 
                             
        System.Debug('\n ######### lst_EstimtdErng '+lst_EstimtdErng) ;                    
        if(lst_EstimtdErng.size() > 0)                    
            System.Debug('\n EarningCalController loadData -7 lst_EstimtdErng -> '+lst_EstimtdErng+' and size ->  '+lst_EstimtdErng.size());
            
               
        // New list is being populated to display the
        // Estimated Earning Levels
        
        Integer temp = 0;
        for(Leader_Title__c leadTitle : lst_EstimtdErng){
            if(leadTitle.MIN_EST_ERNGs_AMT__c != null){
            //System.Debug('\n EarningCalController loadData -8 ');
            String s = String.valueOf(leadTitle.MIN_EST_ERNGs_AMT__c);
            //System.Debug('\n EarningCalController loadData -9 '+s);
            //System.Debug('\n EarningCalController loadData -10 level '+s.substring(0, s.indexOf('.')));
            //String earningLevel = System.Label.ErngIllustratr_CurrencySymbl+s.substring(0, s.indexOf('.'));
            
            temp = 0;
            temp = Integer.valueOf(s.substring(0, s.indexOf('.')));
            System.Debug('\n EarningCalController loadData temp >>> '+temp+'... and >>> '+temp.format());
            
            String earningLevel = System.Label.ErngIllustratr_CurrencySymbl+String.valueOf(temp.format());
            
            System.Debug('\n EarningCalController loadData -11 earningLevel '+earningLevel);
            lst_EstimtdErngLevel.add(earningLevel);
            
            totalEstimtdErng ++;
            totalEstimtdErngDisplyd ++;
            
            }
        }
        
        if(lst_EstimtdErngLevel.size() > 0)
            lst_EstimtdErngLevel.add(System.Label.ErngIllustratr_NewRep_ZeroVal);
        else
            throw new IllustratrException();
        
        // totalEstimtdErngDisplyd = lst_EstimtdErngLevel.size();
        System.Debug('\n EarningCalController loadData -12 lst_EstimtdErngLevel -> '+lst_EstimtdErngLevel+' and size ->  '+totalEstimtdErngDisplyd);
        
        // Leadership Titles and their corresponding title number
        // are retrieved from Leadership Title table
        lst_EstimtdErng      = [SELECT LCL_LDRSHP_TITL_LANG_DESC_TXT__c, LDRSHP_TITL_LVL_NR__c, MIN_EST_ERNGs_AMT__c
                                FROM   Leader_Title__c 
                                WHERE  Market__r.Market_Id__c=:market.Market_Id__c
                                AND    LANG_CD__c=:userLangCd
                                AND    LCL_LDRSHP_TITL_LANG_DESC_TXT__c NOT IN ('Candidate')
                                AND    LDRSHP_TITL_LVL_NR__c > '0'
                                AND    LDRSHP_TITL_LVL_NR__c != '-2'
                                AND    LDRSHP_TITL_LVL_NR__c <=:marktLdrLevelNum
                                Order by LDRSHP_TITL_LVL_NR__c asc];
         
        System.Debug('\n EarningCalController loadData -13 lst_EstimtdErngLevel -> '+lst_EstimtdErngLevel+' and size ->  '+lst_EstimtdErngLevel.size());
        
        String leaderTitleDesc;
            
        // Filtering the leadership titles
        // based upon the value of max leadership title
        // a Market can have
        for(Leader_Title__c l : lst_EstimtdErng){
            if(l.MIN_EST_ERNGs_AMT__c != null){
            
            leaderTitleDesc = '';
            if(Integer.valueOf(l.LDRSHP_TITL_LVL_NR__c) < Integer.valueOf(marktLdrLevelNum)){
                System.Debug('\n EarningCalController loadData -14 lst_EstimtdErngLevel -> '+l.LCL_LDRSHP_TITL_LANG_DESC_TXT__c);
                
                // After filtering, the list is being populated
                // with filtered data
                if(l.LDRSHP_TITL_LVL_NR__c == '1'){
                   /* try
                    {
                        leaderTitleDesc = System.Label.ErngIllustratr_UnitLeader;
                    }catch(Exception e){*/
                        leaderTitleDesc = l.LCL_LDRSHP_TITL_LANG_DESC_TXT__c;
                    //}
                }else if(l.LDRSHP_TITL_LVL_NR__c == '2'){
                   /* try{
                        leaderTitleDesc = System.Label.ErngIllustratr_AdvUnitLeader;
                    }catch(Exception e){*/
                        leaderTitleDesc = l.LCL_LDRSHP_TITL_LANG_DESC_TXT__c;
                    //}   
                }else if(l.LDRSHP_TITL_LVL_NR__c == '3'){
                   /* try{
                        leaderTitleDesc = System.Label.ErngIllustratr_ExecLeader;
                    }catch(Exception e){*/
                        leaderTitleDesc = l.LCL_LDRSHP_TITL_LANG_DESC_TXT__c;
                   // }   
                }else if(l.LDRSHP_TITL_LVL_NR__c == '4'){
                   /* try{
                        leaderTitleDesc = System.Label.ErngIllustratr_SrExecLeader;
                    }catch(Exception e){*/
                        leaderTitleDesc = l.LCL_LDRSHP_TITL_LANG_DESC_TXT__c;
                   // }   
                }else if(l.LDRSHP_TITL_LVL_NR__c == '5'){
                    /*try{
                        leaderTitleDesc = System.Label.ErngIllustratr_SrExecLeader1;
                    }catch(Exception e){*/
                        leaderTitleDesc = l.LCL_LDRSHP_TITL_LANG_DESC_TXT__c;
                    //}   
                }else if(l.LDRSHP_TITL_LVL_NR__c == '6'){
                    /*try{
                        leaderTitleDesc = System.Label.ErngIllustratr_SrExecLeader2;
                    }catch(Exception e){*/
                        leaderTitleDesc = l.LCL_LDRSHP_TITL_LANG_DESC_TXT__c;
                    //}   
                }else if(l.LDRSHP_TITL_LVL_NR__c == '7'){
                    /*try{
                        leaderTitleDesc = System.Label.ErngIllustratr_SrExecLeader3;
                    }catch(Exception e){*/
                        leaderTitleDesc = l.LCL_LDRSHP_TITL_LANG_DESC_TXT__c;
                    //}   
                }else if(l.LDRSHP_TITL_LVL_NR__c == '8'){
                   /* try{
                        leaderTitleDesc = System.Label.ErngIllustratr_SrExecLeader4;
                    }catch(Exception e){*/
                        leaderTitleDesc = l.LCL_LDRSHP_TITL_LANG_DESC_TXT__c;
                   // }   
                }
                    
                /*else if(l.LDRSHP_TITL_LVL_NR__c == '5')
                    leaderTitleDesc = System.Label.ErngIllustratr_TotUnitSl;    */
                        
                lst_TitleDesc.add(leaderTitleDesc);
            }
            
        }
            
        }
        
        if(lst_TitleDesc.size() == 0){
            throw new IllustratrException();    
        }
        
        System.Debug('\n EarningCalController loadData -15 lst_EstimtdErngLevel -> '+lst_TitleDesc+' and size ->  '+lst_TitleDesc.size());
                
        // Row is created based upon the no. of
        // leadership titles retrieved from Leader
        // Title table, based upon the value of max 
        // leadership title a Market can have
        for(integer counter = 0; counter < totalEstimtdErngDisplyd - 1 ; counter++){  // lst_TitleDesc.size()
            System.Debug('\n EarningCalController loadData -16');
            integer i = math.mod(counter, 2);
            
            // Checking whether row is even or odd
            if(i == 0){
            System.Debug('\n EarningCalController loadData -17');
                rowDisplayed +='<tr class="bg_gry_tbl" ><td class="lft">'+lst_TitleDesc[counter]+':</td><td class="rht">'+System.Label.ErngIllustratr_NewRep_ZeroVal+'</td></tr>';   
            }else{
            System.Debug('\n EarningCalController loadData -18');    
                rowDisplayed +='<tr><td class="lft">'+lst_TitleDesc[counter]+':</td><td class="rht">'+System.Label.ErngIllustratr_NewRep_ZeroVal+'</td></tr>';       
            }
        }
        
        rowDisplayed += '</table>';
        System.Debug('\n EarningCalController loadData -19 rowDisplayed \n'+rowDisplayed);
                
        newRepDisplayed = '<h2>'+System.Label.ErngIllustratr_NewRep+'</h2>'+'<p>'+System.Label.ErngIllustratr_TitleRequiremnt+':'+'</p>';
        System.Debug('\n EarningCalController loadData -20 newRepDisplayed \n'+newRepDisplayed);
        
        newRepPic = System.Label.ErngIllustratr_NewRep_PicUrl;
       // newRepPic = '/servlet/servlet.ImageServer?id=015Z00000009AHg&oid=00DZ00000006TPZ';
        System.Debug('\n EarningCalController loadData -21 newRepDisplayed \n'+newRepPic);
       
        }catch(Exception e){
            System.Debug('\n Exception Caught in EarningCalController loadData -\n'+e);            
            String errorId = ErrorHandler.handleError(e.getMessage());
            errPage = Page.ErrorPage;
            errPage.getParameters().put('errId',errorId);
            
            return errPage;
        }
      
        return null;
      
    }// method - END
    
        
    
    /**
        *  This method is used to retrieve data from 
        *  Leader Title based upon selected Estimated Earning. 
        *  After retrieving data, new custom object is being 
        *  populated and used to display data in page.
        *
        *  Created on 12 Mar, 2012
        *  Created by Raktim Sarkar
        *
        *  Modified - method getData on 16 Mar, 2012
        *  LeaderShipTitle field of Market is being considered
        *  to retrieve Earning levels from Leader Title table.
        *  Modified by Raktim Sarkar
        *
        *
    **/
    @RemoteAction
    global static String getData(Integer sno)
    {
        Earning_Illustrator_Row__c illustratorRow = new Earning_Illustrator_Row__c();
        Leader_Title__c leaderTitle;
        Integer maxLeaderTitles;
        Integer indexTitles = 0;
        Integer counter = 0;
        
        String rowTobDisplyd;
        String leaderTitleDesc;
        String titleHeadr;
        String estdEarning;
        String leaderTitleNm;
        String leaderTitleDescrpLbl;
        String info_Prsnl_Sale;
        String info_Grp_Sale;
        String marktLdrLevelNum;
        Integer LowestLdrLvlNbr;
        Integer LdrTitleNbr;
        
        List<String> lst_TitleDesc = new List<String>();
        
        try{
        User currUsr    =   [SELECT MRKT_ID__c, LanguageLocaleKey ,MRKT_ID_ACCT_NR_KEY__c
                             FROM   User
                             WHERE  Id = :UserInfo.getUserId()
                            ];
                           
        Market__c market =  [SELECT Market_Id__c, Max_Ldr_Titl_LVL__c // new field needs to be here
                             FROM Market__c 
                             WHERE Market_ID__c=:currUsr.MRKT_ID__c];                               
        
        marktLdrLevelNum = String.valueOf(market.Max_Ldr_Titl_LVL__c);     
                            
        String userLangCode = currUsr.LanguageLocaleKey;        
        
        System.Debug('\n EarningCalController . getData -1  sno -> '+sno);
        
        List<Leader_Title__c> lst_LeaderTitle  =  [SELECT MIN_EST_ERNGs_AMT__c, LCL_LDRSHP_TITL_LANG_DESC_TXT__c, LDRSHP_TITL_LVL_NR__c
                                                   FROM   Leader_Title__c 
                                                   WHERE  Market__r.Market_Id__c=:market.Market_Id__c
                                                   AND    LANG_CD__c=:userLangCode
                                                   AND    LCL_LDRSHP_TITL_LANG_DESC_TXT__c NOT IN ('Candidate')
                                                   AND    LDRSHP_TITL_LVL_NR__c > '0'
                                                   AND    LDRSHP_TITL_LVL_NR__c != '-2'
                                                   AND    LDRSHP_TITL_LVL_NR__c <=:marktLdrLevelNum                                               
                                                   ORDER BY LDRSHP_TITL_LVL_NR__c desc]; // MIN_EST_ERNGs_AMT__c is replaced - 6th Sept 2013 by Raktim
        System.Debug('\n EarningCalController . getData -2  lst_LeaderTitle -> '+lst_LeaderTitle);
        
        if(lst_LeaderTitle.size() > 0){
            System.Debug('\n EarningCalController . getData -3 lst_LeaderTitle size > 0 ');
            
            for(Leader_Title__c l : lst_LeaderTitle)
            {
                if(l.MIN_EST_ERNGs_AMT__c != null){
                    counter++;
                }   
            }
            System.Debug('\n EarningCalController . getData -4 lst_LeaderTitle counter --> '+counter);
            mapEstimtdErng = new Map<Integer, String>();
            mapTitlLvl = new Map<Integer, String>();
            //mapEstimtdErng.put(0, '0'+'|'+'');
            mapEstimtdErng.put(0, '0');
            mapTitlLvl.put(0, '');
                        
            for(Leader_Title__c l : lst_LeaderTitle)
            {
                if(l.MIN_EST_ERNGs_AMT__c != null){
                    mapEstimtdErng.put(counter, String.valueOf(l.MIN_EST_ERNGs_AMT__c));
                    mapTitlLvl.put(counter, l.LCL_LDRSHP_TITL_LANG_DESC_TXT__c);
                    counter--;
                }
            }
            
            System.Debug('\n EarningCalController . getData -5 mapEstimtdErng \n'+mapEstimtdErng);
            System.Debug('\n EarningCalController . getData -5 mapTitlLvl \n'+mapTitlLvl);
            
       //     counter = lst_LeaderTitle.size();
            
            lst_LeaderTitle  =  [SELECT LCL_LDRSHP_TITL_LANG_DESC_TXT__c, LDRSHP_TITL_LVL_NR__c, MIN_EST_ERNGs_AMT__c, EXEC_IND__c
                                 FROM   Leader_Title__c 
                                 WHERE  Market__r.Market_Id__c=:market.Market_Id__c
                                 AND    LANG_CD__c=:userLangCode
                                 AND    LCL_LDRSHP_TITL_LANG_DESC_TXT__c NOT IN ('Candidate')
                                 AND    LDRSHP_TITL_LVL_NR__c > '0'
                                 AND    LDRSHP_TITL_LVL_NR__c != '-2'
                                 AND    LDRSHP_TITL_LVL_NR__c <=:marktLdrLevelNum
                                 ORDER BY LDRSHP_TITL_LVL_NR__c];
                                 
             System.Debug('\n EarningCalController . getData -6 lst_LeaderTitle  size  ->  '+lst_LeaderTitle.size());                    
             for(Leader_Title__c l : lst_LeaderTitle)
             {
                if(l.MIN_EST_ERNGs_AMT__c != null){
                    counter++;
                }
                if(l.EXEC_IND__c == 'Y'){
                    LowestLdrLvlNbr = Integer.valueOf(l.LDRSHP_TITL_LVL_NR__c);
                }
             }
             for(Leader_Title__c l : lst_LeaderTitle)
             {
                 if(l.EXEC_IND__c == 'Y')
                 {
                     LdrTitleNbr = Integer.valueOf(l.LDRSHP_TITL_LVL_NR__c); 
                     if(LdrTitleNbr < LowestLdrLvlNbr)
                     {
                         LowestLdrLvlNbr  = LdrTitleNbr; 
                     }
                 }    
             }                              
                                 
        //    counter = lst_LeaderTitle.size();
            
        //    counter = 0;
            for(Leader_Title__c l : lst_LeaderTitle){
                if(l.MIN_EST_ERNGs_AMT__c != null)
                {
                leaderTitleDescrpLbl = '';
                System.Debug('\n EarningCalController . getData -7 l.LDRSHP_TITL_LVL_NR__c -> '+l.LDRSHP_TITL_LVL_NR__c);
                if(Integer.valueOf(l.LDRSHP_TITL_LVL_NR__c) < counter){
                    System.Debug('\n EarningCalController . getData -8 l.LDRSHP_TITL_LVL_NR__c -> '+l.LCL_LDRSHP_TITL_LANG_DESC_TXT__c);
                
                    // After filtering, the list is being populated
                    // with filtered data
                    if(l.LDRSHP_TITL_LVL_NR__c == '1'){
                        /*try{
                            leaderTitleDescrpLbl = System.Label.ErngIllustratr_UnitLeader;
                        }catch(Exception e){*/
                            leaderTitleDescrpLbl = l.LCL_LDRSHP_TITL_LANG_DESC_TXT__c;
                      //  }   
                    }else if(l.LDRSHP_TITL_LVL_NR__c == '2'){
                      /*  try{
                            leaderTitleDescrpLbl = System.Label.ErngIllustratr_AdvUnitLeader;
                        }catch(Exception e){*/
                            leaderTitleDescrpLbl = l.LCL_LDRSHP_TITL_LANG_DESC_TXT__c;
                       // }   
                    }else if(l.LDRSHP_TITL_LVL_NR__c == '3'){
                      /*  try{
                            leaderTitleDescrpLbl = System.Label.ErngIllustratr_ExecLeader;
                        }catch(Exception e){*/
                            leaderTitleDescrpLbl = l.LCL_LDRSHP_TITL_LANG_DESC_TXT__c;
                      //  }   
                    }else if(l.LDRSHP_TITL_LVL_NR__c == '4'){
                       /* try{
                            leaderTitleDescrpLbl = System.Label.ErngIllustratr_SrExecLeader;
                        }catch(Exception e){*/
                            leaderTitleDescrpLbl = l.LCL_LDRSHP_TITL_LANG_DESC_TXT__c;
                      //  }   
                    }else if(l.LDRSHP_TITL_LVL_NR__c == '5'){
                       /* try{
                            leaderTitleDescrpLbl = System.Label.ErngIllustratr_SrExecLeader1;
                        }catch(Exception e){*/
                            leaderTitleDescrpLbl = l.LCL_LDRSHP_TITL_LANG_DESC_TXT__c;
                        //}   
                    }else if(l.LDRSHP_TITL_LVL_NR__c == '6'){
                        /*try{
                            leaderTitleDescrpLbl = System.Label.ErngIllustratr_SrExecLeader2;
                        }catch(Exception e){*/
                            leaderTitleDescrpLbl = l.LCL_LDRSHP_TITL_LANG_DESC_TXT__c;
                        //}   
                    }else if(l.LDRSHP_TITL_LVL_NR__c == '7'){
                      /*  try{
                            leaderTitleDescrpLbl = System.Label.ErngIllustratr_SrExecLeader3;
                        }catch(Exception e){*/
                            leaderTitleDescrpLbl = l.LCL_LDRSHP_TITL_LANG_DESC_TXT__c;
                       // }   
                    }else if(l.LDRSHP_TITL_LVL_NR__c == '8'){
                        /*try{
                            leaderTitleDescrpLbl = System.Label.ErngIllustratr_SrExecLeader4;
                        }catch(Exception e){*/
                            leaderTitleDescrpLbl = l.LCL_LDRSHP_TITL_LANG_DESC_TXT__c;
                      //  }   
                    }
                    lst_TitleDesc.add(leaderTitleDescrpLbl);                   
                 
                }                
                }
            
            }
            
            System.Debug('\n EarningCalController . getData -9 counter -> '+counter);
        
            System.Debug('\n EarningCalController . getData -10 l.lst_TitleDesc -> '+lst_TitleDesc+' and size ---> '+lst_TitleDesc.size());
            
        }
        
        if( sno > 0)
        {
        //estdEarning_LeadTitle    =   (String) mapEstimtdErng.get(sno); estdEarning
        estdEarning = (String) mapEstimtdErng.get(sno);     
        leaderTitleNm = (String) mapTitlLvl.get(sno); 
        System.Debug('\n EarningCalController . getData -11 estdEarning ->  '+estdEarning);
        System.Debug('\n EarningCalController . getData -11 leaderTitleNm ->  '+leaderTitleNm);
        
        /*List<String> lst_QueryArgs;
        if(!estdEarning_LeadTitle.equals('') && estdEarning_LeadTitle.indexOf('|') > -1)
            lst_QueryArgs           =   estdEarning_LeadTitle.split('\\|');
        System.Debug('\n EarningCalController . getData -12 lst_QueryArgs ->  '+lst_QueryArgs);*/
        
        /*if(lst_QueryArgs.size() == 2)
        {*/
            //System.Debug('\n EarningCalController . getData -13 QueryArgs(1) ->  '+lst_QueryArgs[0]+' and QueryArgs(2) -> '+lst_QueryArgs[1]);
            System.Debug('\n EarningCalController . getData -13 QueryArgs(1) ->  '+estdEarning+' and QueryArgs(2) -> '+leaderTitleNm);
            System.Debug('\n EarningCalController . getData -14 userLangCode ->  '+userLangCode);
          //  System.Debug('\n EarningCalController . getData -9 Market_Id__c ->  '+market.Market_Id__c);
            
             
            Schema.DescribeSObjectResult descResult= Leader_Title__c.sObjectType.getDescribe();
            Map<String, Schema.SObjectField> fldMap = descResult.fields.getMap();
       
            String tempSoqlStart = 'select l.min_est_erngs_amt__c, l.lcl_ldrshp_titl_lang_desc_txt__c, l.min_prsnl_sls_reqd_amt__c, '+
                                   'l.min_grp_sls_reqd_amt__c, l.min_rep_rcrtmnts_reqd_nr__c, l.exec_ind__c, LDRSHP_TITL_LVL_NR__c';
        
            String tempSoqlMid =' from '+descResult.getLocalName()+' l';
            System.debug('\n EarningCalController . getData -15 tempSoql #### '+tempSoqlStart);
        
            Double earning = Decimal.valueOf(estdEarning);      //Decimal.valueOf(lst_QueryArgs[0])
            String leadTitle = leaderTitleNm;                     //lst_QueryArgs[1]
            String marketId = market.Market_Id__c;
            
            System.debug('\n EarningCalController . getData -16 earning '+earning+', leadTitle '+leadTitle+', marketId '+marketId+', userLangCode : '+userLangCode);
        
            String tempSoqlEnd=' where l.LANG_CD__c=:userLangCode and l.Market__r.Market_Id__c=:marketId '+
                               'and l.MIN_EST_ERNGs_AMT__c=:earning and l.LCL_LDRSHP_TITL_LANG_DESC_TXT__c=:leadTitle';
                  
            System.debug('\n EarningCalController . getData -17 tempSoql finally  #### '+(tempSoqlStart+tempSoqlMid+tempSoqlEnd));
            
            String queryFields = tempSoqlStart +tempSoqlMid +tempSoqlEnd;
            System.debug('\n EarningCalController . getData -18 queryFields finally  #### '+queryFields);
            
            leaderTitle = Database.query(queryFields);
            String ExecInd = leaderTitle.Exec_Ind__c;
            LdrTitleNbr = Integer.valueOf(leadertitle.LDRSHP_TITL_LVL_NR__c);
            
            System.debug('\n EarningCalController . getData -19 '+leaderTitle);
            leaderTitleDesc = leaderTitle.lcl_ldrshp_titl_lang_desc_txt__c;
            
            rowTobDisplyd = '<table width="100%" border="0" cellspacing="0" cellpadding="0" class="ear_tab"><tr><td class="lft">'+System.Label.ErngIllustrator_PersnVol+'</td>';
            
            if(leaderTitle.min_prsnl_sls_reqd_amt__c != null)
                info_Prsnl_Sale = String.valueOf(leaderTitle.min_prsnl_sls_reqd_amt__c);
            else
                info_Prsnl_Sale = String.valueOf(0.000);
        //    rowTobDisplyd +='<td class="rht">'+System.Label.ErngIllustratr_CurrencySymbl+String.valueOf(leaderTitle.min_prsnl_sls_reqd_amt__c).substring(0, String.valueOf(leaderTitle.min_prsnl_sls_reqd_amt__c).indexOf('.'))+'</td></td></tr>';
            rowTobDisplyd +='<td class="rht">'+System.Label.ErngIllustratr_CurrencySymbl+String.valueOf(Integer.valueOf(info_Prsnl_Sale.substring(0, info_Prsnl_Sale.indexOf('.'))).format())+'</td></td></tr>';
            String Label = (ExecInd=='Y' && LdrTitleNbr>=LowestLdrLvlNbr+1)? System.Label.ErngIllustratr_TotGroupSl : System.Label.ErngIllustratr_TotUnitSl;
            rowTobDisplyd +='<tr class="bg_gry_tbl" ><td class="lft">'+Label+'</td>'; 
           
            if(leaderTitle.min_grp_sls_reqd_amt__c != null)
                info_Grp_Sale = String.valueOf(leaderTitle.min_grp_sls_reqd_amt__c);
            else
                info_Grp_Sale = String.valueOf(0.000);
            //rowTobDisplyd +='<td class="rht">'+System.Label.ErngIllustratr_CurrencySymbl+String.valueOf(leaderTitle.min_grp_sls_reqd_amt__c).substring(0, String.valueOf(leaderTitle.min_grp_sls_reqd_amt__c).indexOf('.'))+'</td></tr>';
            rowTobDisplyd +='<td class="rht">'+System.Label.ErngIllustratr_CurrencySymbl+String.valueOf(Integer.valueOf(info_Grp_Sale.substring(0, info_Grp_Sale.indexOf('.'))).format())+'</td></tr>';
            rowTobDisplyd +='<tr><td class="lft">'+System.Label.ErngIllustratr_G1ActiveReps+'</td><td class="rht">'+(leaderTitle.min_rep_rcrtmnts_reqd_nr__c != null ? leaderTitle.min_rep_rcrtmnts_reqd_nr__c : 0)+'</td></tr>';
            
            tempSoqlStart = 'select ';
            tempSoqlMid =' from '+descResult.getLocalName()+' l';
            tempSoqlEnd=' where l.LANG_CD__c=:userLangCode and l.Market__r.Market_Id__c=:marketId '+
                        'and l.MIN_EST_ERNGs_AMT__c=:earning and l.LCL_LDRSHP_TITL_LANG_DESC_TXT__c=:leadTitle';
                        
            List<String> lst_Flds =  new List<String>();
          //  lst_Flds.addAll(fldMap.keySet());
            
            Set<String> set_AllFlds = fldMap.keySet();
            for(String s : set_Allflds){
                if(s.indexOf('min_') > -1 && s.indexOf('lvl_titl_reqd') > -1){
                    lst_Flds.add(s);
                }
            }
                
            System.debug('\n ########## Field Size ->  '+lst_Flds.size()+' ... and lst_Flds \n'+lst_Flds);
            List<String> lst_NewFlds = new List<String>();
            
            for(integer i = 0; i < lst_Flds.size(); i++){
                String old = lst_Flds[i];
                if(old.indexOf('min_frst') > -1){
                    old = 'min_01_lvl_titl_reqd_nr__c';                
                    
                    lst_NewFlds.add(old);
                }else if(old.indexOf('min_scn') > -1){
                    old = 'min_02_lvl_titl_reqd_nr__c';
                    
                     lst_NewFlds.add(old);
                }else if(old.indexOf('min_thrd') > -1){
                    old = 'min_03_lvl_titl_reqd_nr__c';
                     
                    lst_NewFlds.add(old);
                }else if(old.indexOf('min_4_lvl') > -1){
                    old = 'min_04_lvl_titl_reqd_nr__c';
                   
                    lst_NewFlds.add(old);
                }else if(old.indexOf('min_5_lvl') > -1){
                    old = 'min_05_lvl_titl_reqd_nr__c';
                    
                    lst_NewFlds.add(old);
                }else if(old.indexOf('min_6_lvl') > -1){
                    old = 'min_06_lvl_titl_reqd_nr__c';
                    
                    lst_NewFlds.add(old);
                }else if(old.indexOf('min_7_lvl') > -1){
                    old = 'min_07_lvl_titl_reqd_nr__c';
                    
                    lst_NewFlds.add(old);
                }else if(old.indexOf('min_8_lvl') > -1){
                    old = 'min_08_lvl_titl_reqd_nr__c';
                    
                    lst_NewFlds.add(old);
                }else if(old.indexOf('min_9_lvl') > -1){
                    old = 'min_09_lvl_titl_reqd_nr__c';
                    
                    lst_NewFlds.add(old);
                }else{
                      lst_NewFlds.add(old);
                }
             
            }
            
            lst_Flds = lst_NewFlds; 
            
            lst_Flds.sort();
            System.debug('\n EarningCalController . getData -20 lst_Flds SORTDED -------- \n'+lst_Flds);      
            
            for(String fldName: lst_NewFlds){
                if(fldName.indexOf('lvl_titl_reqd_nr__c') > -1){
                    String field = fldName;
                    System.debug('\n EarningCalController . getData field inside Loop >>> '+field); 
                    if(field.indexOf('min_01_lvl') > -1){
                    indexTitles = 1;    
                    }else if(field.indexOf('min_02_lvl') > -1){
                    indexTitles = 2;    
                    }else if(field.indexOf('min_03_lvl') > -1){
                    indexTitles = 3;    
                    }else if(field.indexOf('min_04_lvl') > -1){
                    indexTitles = 4;    
                    }else if(field.indexOf('min_05_lvl') > -1){
                    indexTitles = 5;    
                    }else if(field.indexOf('min_06_lvl') > -1){
                    indexTitles = 6;    
                    }else if(field.indexOf('min_07_lvl') > -1){
                    indexTitles = 7;    
                    }else if(field.indexOf('min_08_lvl') > -1){
                    indexTitles = 8;    
                    }else if(field.indexOf('min_09_lvl') > -1){
                    indexTitles = 9;    
                    }else if(field.indexOf('min_10_lvl') > -1){
                    indexTitles = 10;   
                    }else if(field.indexOf('min_11_lvl') > -1){
                    indexTitles = 11;   
                    }else if(field.indexOf('min_12_lvl') > -1){
                    indexTitles = 12;   
                    }else if(field.indexOf('min_13_lvl') > -1){
                    indexTitles = 13;   
                    }else if(field.indexOf('min_14_lvl') > -1){
                    indexTitles = 14;   
                    }else if(field.indexOf('min_15_lvl') > -1){
                    indexTitles = 15;   
                    }
                
                    System.Debug('\n EarningCalController . getData -21  indexTitles ->  #### '+indexTitles);
                    if(indexTitles < counter ){
                        tempSoqlStart+='l.'+fldName+',';
                    }
                
                System.debug('\n EarningCalController . getData -22 tempSoqlStart #### '+tempSoqlStart);
                }
            }
            System.debug('\n EarningCalController . getData -23 tempSoqlStart Aftr Loop #### \n'+tempSoqlStart);
            
            
            if(tempSoqlStart.indexOf('min_01_lvl_titl_reqd_nr__c') > -1){
                tempSoqlStart = tempSoqlStart.replace('min_01_lvl_titl_reqd_nr__c', 'min_frst_lvl_titl_reqd_nr__c');
            }
            
            if(tempSoqlStart.indexOf('min_02_lvl_titl_reqd_nr__c') > -1){
                tempSoqlStart = tempSoqlStart.replace('min_02_lvl_titl_reqd_nr__c', 'min_scn_lvl_titl_reqd_nr__c');
            }
            System.debug('\n EarningCalController . getData -20 2 %%%%%%%%%%%%% Aftr Loop #### \n'+tempSoqlStart);
            
            if(tempSoqlStart.indexOf('min_03_lvl_titl_reqd_nr__c') > -1){
                tempSoqlStart = tempSoqlStart.replace('min_03_lvl_titl_reqd_nr__c', 'min_thrd_lvl_titl_reqd_nr__c');
            }
            
            if(tempSoqlStart.indexOf('min_04_lvl_titl_reqd_nr__c') > -1){
                tempSoqlStart = tempSoqlStart.replace('min_04_lvl_titl_reqd_nr__c', 'min_4_lvl_titl_reqd_nr__c');
            }
            if(tempSoqlStart.indexOf('min_05_lvl_titl_reqd_nr__c') > -1){
                tempSoqlStart = tempSoqlStart.replace('min_05_lvl_titl_reqd_nr__c', 'min_5_lvl_titl_reqd_nr__c');
            }
            if(tempSoqlStart.indexOf('min_06_lvl_titl_reqd_nr__c') > -1){
                tempSoqlStart = tempSoqlStart.replace('min_06_lvl_titl_reqd_nr__c', 'min_6_lvl_titl_reqd_nr__c');
            }
            if(tempSoqlStart.indexOf('min_07_lvl_titl_reqd_nr__c') > -1){
                tempSoqlStart = tempSoqlStart.replace('min_07_lvl_titl_reqd_nr__c', 'min_7_lvl_titl_reqd_nr__c');
            }
            if(tempSoqlStart.indexOf('min_08_lvl_titl_reqd_nr__c') > -1){
                tempSoqlStart = tempSoqlStart.replace('min_08_lvl_titl_reqd_nr__c', 'min_8_lvl_titl_reqd_nr__c');
            }
            if(tempSoqlStart.indexOf('min_09_lvl_titl_reqd_nr__c') > -1){
                tempSoqlStart = tempSoqlStart.replace('min_09_lvl_titl_reqd_nr__c', 'min_9_lvl_titl_reqd_nr__c');
            }
            System.debug('\n EarningCalController . getData -24 tempSoqlStart #### '+tempSoqlStart);
            
            queryFields = tempSoqlStart.substring(0, tempSoqlStart.lastIndexof(',')) +tempSoqlMid +tempSoqlEnd;
            System.debug('\n EarningCalController . getData -25 queryFields #### '+queryFields);
            
            leaderTitle = Database.query(queryFields);
            System.debug('\n EarningCalController . getData -26 leaderTitle #### \n'+leaderTitle);
            
            String s = queryFields.replace('select ', '');
            s = s.substring(0, s.indexOf(' from'));
            System.debug('\n EarningCalController . getData -27  s #### \n'+s);
            
            List<String> fields_LeadTitle = new List<String>();
            
            fields_LeadTitle = s.split(',');
            System.debug('\n EarningCalController . getData -28 fields_LeadTitle #### \n'+fields_LeadTitle);
            
            List<String> lst_Values = new List<String>();
            
            for(String field :fields_LeadTitle){
                
                String fieldname = field.substring(2);
                System.debug('\n EarningCalController . getData -29  fieldname >>> '+fieldname);
                String value = String.valueOf(leaderTitle.get(fieldname.touppercase()));
                System.debug('\n EarningCalController . getvalue -30 leaderTitle.fieldname >>>  '+value);               
                
                lst_Values.add(value);
            }
            
            System.debug('\n EarningCalController . getData-31 lst_TitleDesc size  #### '+lst_TitleDesc.size());  
            System.debug('\n EarningCalController . getData counter  #### '+counter);         
            
            for(integer counter1 = 0; counter1 < lst_TitleDesc.size(); counter1++)   ////lst_TitleDesc.size()
            {
                System.Debug('\n EarningCalController . getData -32 '+counter1);
                integer i = math.mod(counter1, 2);
                for(integer counter2 = counter1; counter2 < = counter1; counter2++){
                System.Debug('\n EarningCalController . getData -33 '+counter2);
                System.Debug('\n EarningCalController . getData -34 lst_TitleDesc[counter1] '+lst_TitleDesc[counter1]);
                System.Debug('\n EarningCalController . getData 35 lst_Values[counter2] '+lst_Values[counter2]);
                
                // Checking whether row is even or odd
                    if(i == 0){
                        System.Debug('\n EarningCalController . getData -36');
                        rowTobDisplyd +='<tr class="bg_gry_tbl" ><td class="lft">'+lst_TitleDesc[counter1]+':</td><td class="rht">'+(lst_Values[counter2] != null ? lst_Values[counter2] : '0')+'</td></tr>';  
                    }else{
                        System.Debug('\n EarningCalController . getData -37');  
                        rowTobDisplyd +='<tr><td class="lft">'+lst_TitleDesc[counter1]+':</td><td class="rht">'+(lst_Values[counter2] != null ? lst_Values[counter2] : '0')+'</td></tr>';      
                    }
                }
            }                        
            
            rowTobDisplyd +='</table>';    
                
           // }  
     
            titleHeadr = '<h2>'+leaderTitleDesc+'</h2><p>'+System.Label.ErngIllustratr_TitleRequiremnt+':</p>';
    
            rowTobDisplyd += '--'+titleHeadr;
            System.Debug('\n EarningCalController . getData -38 rowTobDisplyd @@@@ \n'+rowTobDisplyd);
    
        }else{
            rowTobDisplyd = '<table width="100%" border="0" cellspacing="0" cellpadding="0" class="ear_tab"><tr><td class="lft">'+System.Label.ErngIllustrator_PersnVol+'</td>';
            
            rowTobDisplyd +='<td class="rht">'+System.Label.ErngIllustratr_NewRep_ZeroVal+'</td></td></tr>';
            rowTobDisplyd +='<tr class="bg_gry_tbl" ><td class="lft">'+System.Label.ErngIllustratr_TotUnitSl+'</td>';
            rowTobDisplyd +='<td class="rht">'+System.Label.ErngIllustratr_NewRep_ZeroVal+'</td></tr>';
            rowTobDisplyd +='<tr><td class="lft">'+System.Label.ErngIllustratr_G1ActiveReps+'</td><td class="rht">'+'0'+'</td></tr>';
            System.Debug('\n EarningCalController . getData -39 rowTobDisplyd @@@@ \n'+rowTobDisplyd);
        
            lst_LeaderTitle      = [SELECT LCL_LDRSHP_TITL_LANG_DESC_TXT__c, LDRSHP_TITL_LVL_NR__c, MIN_EST_ERNGs_AMT__c
                                    FROM   Leader_Title__c 
                                    WHERE  Market__r.Market_Id__c=:market.Market_Id__c
                                    AND    LANG_CD__c=:userLangCode
                                    AND    LCL_LDRSHP_TITL_LANG_DESC_TXT__c NOT IN ('Candidate')
                                    AND    LDRSHP_TITL_LVL_NR__c > '0'    
                                    AND    LDRSHP_TITL_LVL_NR__c != '-2'                            
                                    AND    LDRSHP_TITL_LVL_NR__c <=: marktLdrLevelNum
                                    ORDER BY LDRSHP_TITL_LVL_NR__c];
         
            System.Debug('\n EarningCalController . getData -40 counter >>> '+counter);
        
            lst_TitleDesc = new List<String>();                  
            for(Leader_Title__c leadTitle : lst_LeaderTitle){
                if(leadTitle.MIN_EST_ERNGs_AMT__c != null){
                if(Integer.valueOf(leadTitle.LDRSHP_TITL_LVL_NR__c) < counter){
                    
                    if(leadTitle.LDRSHP_TITL_LVL_NR__c == '1'){
                   /*     try{
                            leaderTitleDescrpLbl = System.Label.ErngIllustratr_UnitLeader;
                        }catch(Exception e){*/
                            leaderTitleDescrpLbl = leadTitle.LCL_LDRSHP_TITL_LANG_DESC_TXT__c;
                     //   }   
                    }else if(leadTitle.LDRSHP_TITL_LVL_NR__c == '2'){
                       /* try{
                            leaderTitleDescrpLbl = System.Label.ErngIllustratr_AdvUnitLeader;
                        }catch(Exception e){*/
                            leaderTitleDescrpLbl = leadTitle.LCL_LDRSHP_TITL_LANG_DESC_TXT__c;
                      //  }   
                    }else if(leadTitle.LDRSHP_TITL_LVL_NR__c == '3'){
                     /*   try{
                            leaderTitleDescrpLbl = System.Label.ErngIllustratr_ExecLeader;
                        }catch(Exception e){*/
                            leaderTitleDescrpLbl = leadTitle.LCL_LDRSHP_TITL_LANG_DESC_TXT__c;
                       // }   
                    }else if(leadTitle.LDRSHP_TITL_LVL_NR__c == '4'){
                    /*    try{
                            leaderTitleDescrpLbl = System.Label.ErngIllustratr_SrExecLeader;
                        }catch(Exception e){*/
                            leaderTitleDescrpLbl = leadTitle.LCL_LDRSHP_TITL_LANG_DESC_TXT__c;
                      //  }   
                    }else if(leadTitle.LDRSHP_TITL_LVL_NR__c == '5'){
                       /* try{
                            leaderTitleDescrpLbl = System.Label.ErngIllustratr_SrExecLeader1;
                        }catch(Exception e){*/
                            leaderTitleDescrpLbl = leadTitle.LCL_LDRSHP_TITL_LANG_DESC_TXT__c;
                       // }   
                    }else if(leadTitle.LDRSHP_TITL_LVL_NR__c == '6'){
                       /* try{
                            leaderTitleDescrpLbl = System.Label.ErngIllustratr_SrExecLeader2;
                        }catch(Exception e){*/
                            leaderTitleDescrpLbl = leadTitle.LCL_LDRSHP_TITL_LANG_DESC_TXT__c;
                      //  }   
                    }else if(leadTitle.LDRSHP_TITL_LVL_NR__c == '7'){
                       /* try{
                            leaderTitleDescrpLbl = System.Label.ErngIllustratr_SrExecLeader3;
                        }catch(Exception e){*/
                            leaderTitleDescrpLbl = leadTitle.LCL_LDRSHP_TITL_LANG_DESC_TXT__c;
                     //   }   
                    }else if(leadTitle.LDRSHP_TITL_LVL_NR__c == '8'){
                       /* try{
                            leaderTitleDescrpLbl = System.Label.ErngIllustratr_SrExecLeader4;
                        }catch(Exception e){*/
                            leaderTitleDescrpLbl = leadTitle.LCL_LDRSHP_TITL_LANG_DESC_TXT__c;
                      //  }   
                    }                   
                
                //lst_TitleDesc.add(leadTitle.LCL_LDRSHP_TITL_LANG_DESC_TXT__c);
                    lst_TitleDesc.add(leaderTitleDescrpLbl);
                }
                }
            }                      
            System.Debug('\n EarningCalController . getData -41 lst_TitleDesc >>> '+lst_TitleDesc);
        
            for(integer i = 0; i < lst_TitleDesc.size(); i++){
                System.Debug('\n EarningCalController . getData -42');
                integer rowCount = math.mod(i, 2);
            
            // Checking whether row is even or odd
                if(rowCount == 0){
                    System.Debug('\n EarningCalController . getData -43');
                    rowTobDisplyd +='<tr class="bg_gry_tbl" ><td class="lft">'+lst_TitleDesc[i]+':</td><td class="rht">0</td></tr>';   
                }else{
                    System.Debug('\n EarningCalController . getData -44');    
                    rowTobDisplyd +='<tr><td class="lft">'+lst_TitleDesc[i]+':</td><td class="rht">0</td></tr>';       
                }
            }                     
            System.Debug('\n EarningCalController . getData -45 rowTobDisplyd @@@@ \n'+rowTobDisplyd);
        
            titleHeadr = '<h2>'+System.Label.ErngIllustratr_NewRep+'</h2><p>'+System.Label.ErngIllustratr_TitleRequiremnt+':</p>';
        
            rowTobDisplyd += '--'+titleHeadr;
            System.Debug('\n EarningCalController . getData -46 rowTobDisplyd @@@@ \n'+rowTobDisplyd);
            
        }    
        System.Debug('\n EarningCalController . getData -47 rowTobDisplyd @@@@ \n'+rowTobDisplyd);
    
        }catch(Exception e){
            System.Debug('\n Exception CAUGHT in EarningCalController . getData -48 \n'+e); 
            
        }    
    
        return rowTobDisplyd;
        
    } // End of method
    
    
    /**
        *  This method is used to retrieve picture  
        *  associated with Leadership title, from database.
        *
        *  Created on 12 Mar, 2012
        *  Created by Raktim Sarkar
        *
    **/
    @RemoteAction
    global static String getPicture(Integer sno, Boolean picStat)
    {
        // Retrieving the selected Estimated Earning
        // as well as associated Leadership Title together
        System.Debug('\n EarningCalController . getPicture -1 mapEstimtdErng -> '+mapEstimtdErng);
        System.Debug('\n EarningCalController . getPicture -2 sno -> '+sno+' picStat  '+picStat);        
        
        String urlForPic = '';
        String erngEstmation = '';
        String leaderTitle = '';
        String marktLdrLevelNum;
        
        List<String> lst_ErngTitle;
        
        Leader_Title__c leaderPictr ;
        
        try{        
        User currUsr    =   [SELECT MRKT_ID__c, LanguageLocaleKey
                             FROM   User
                             WHERE  Id = :UserInfo.getUserId()
                             ];
        Market__c market =  [SELECT Market_Id__c, Max_Ldr_Titl_LVL__c // new field needs to be here
                             FROM Market__c 
                             WHERE Market_ID__c=:currUsr.MRKT_ID__c];
                                     
        marktLdrLevelNum = String.valueOf(market.Max_Ldr_Titl_LVL__c);
        if(sno > 0){
            
            if(mapEstimtdErng == null){
                List<Leader_Title__c> lst_LeaderTitle  =  [SELECT MIN_EST_ERNGs_AMT__c, LCL_LDRSHP_TITL_LANG_DESC_TXT__c, LDRSHP_TITL_LVL_NR__c
                                                            FROM   Leader_Title__c 
                                                            WHERE  Market__r.Market_Id__c=:market.Market_Id__c
                                                            AND    LANG_CD__c=:currUsr.LanguageLocaleKey
                                                            AND    LCL_LDRSHP_TITL_LANG_DESC_TXT__c NOT IN ('Candidate')
                                                            AND    LDRSHP_TITL_LVL_NR__c > '0'
                                                            AND    LDRSHP_TITL_LVL_NR__c != '-2'
                                                            AND    LDRSHP_TITL_LVL_NR__c <=:marktLdrLevelNum
                                                           // AND    MIN_EST_ERNGs_AMT__c > 0
                                                            ORDER BY LDRSHP_TITL_LVL_NR__c desc];  // MIN_EST_ERNGs_AMT__c is replaced - 6th Sept 2013 by Raktim           
            
            if(lst_LeaderTitle.size() > 0)
            {
            System.Debug('\n EarningCalController . getPicture lst_LeaderTitle size > 0 ');
            Integer counter = 0;
            
            mapEstimtdErng = new Map<Integer, String>();
            mapTitlLvl = new Map<Integer, String>();
            
            mapEstimtdErng.put(0, '0');
            mapTitlLvl.put(0, '');
            
            for(Leader_Title__c l : lst_LeaderTitle)
            {
                if(l.MIN_EST_ERNGs_AMT__c != null){
                // mapEstimtdErng.put(counter, String.valueOf(l.MIN_EST_ERNGs_AMT__c)+'-'+l.LCL_LDRSHP_TITL_LANG_DESC_TXT__c);
                counter++;
                }   
            }
                        
            for(Leader_Title__c l : lst_LeaderTitle)
            {
                if(l.MIN_EST_ERNGs_AMT__c != null){
                //mapEstimtdErng.put(counter, String.valueOf(l.MIN_EST_ERNGs_AMT__c)+'|'+l.LCL_LDRSHP_TITL_LANG_DESC_TXT__c);
                mapEstimtdErng.put(counter, String.valueOf(l.MIN_EST_ERNGs_AMT__c));
                mapTitlLvl.put(counter, l.LCL_LDRSHP_TITL_LANG_DESC_TXT__c);
                counter--;
                }
            }
            
            System.Debug('\n EarningCalController . getPicture mapEstimtdErng ->  \n'+mapEstimtdErng);
            System.Debug('\n EarningCalController . getPicture mapTitlLvl ->  \n'+mapTitlLvl);
            
                                                                        
            }
            }
            /*String queryArgs = (String) mapEstimtdErng.get(sno);
            System.Debug('\n EarningCalController . getPicture -3 queryArgs -> '+queryArgs);
            
            lst_ErngTitle  =   queryArgs.split('\\|');
            System.Debug('\n EarningCalController . getPicture -4 lst_ErngTitle -> '+lst_ErngTitle);*/
            
            erngEstmation = (String) mapEstimtdErng.get(sno);                      //lst_ErngTitle[0]
            leaderTitle   = (String) mapTitlLvl.get(sno);
            System.Debug('\n EarningCalController . getPicture -5  erngEstmation -> '+erngEstmation+' .. leaderTitle  '+leaderTitle);
            
            Decimal erngEstmtd = Decimal.valueOf(erngEstmation);       //Decimal.valueOf(lst_ErngTitle[0])
            
            leaderPictr = [SELECT GRAPHIC_ERNG_IMG__c 
                           FROM Leader_Title__c l 
                           WHERE l.Market__r.Market_Id__c=:market.Market_Id__c
                           AND   l.LANG_CD__c=:currUsr.LanguageLocaleKey
                           AND   l.MIN_EST_ERNGs_AMT__c=:erngEstmtd
                           AND   l.LCL_LDRSHP_TITL_LANG_DESC_TXT__c=:leaderTitle
                          ];
            System.Debug('\n EarningCalController . getPicture -6  leaderPictr -> '+leaderPictr.GRAPHIC_ERNG_IMG__c);
            
            urlForPic = leaderPictr.GRAPHIC_ERNG_IMG__c;
            System.Debug('\n EarningCalController . getPicture -7  urlForPic -> '+urlForPic);
            
        }else{
            
            urlForPic = System.Label.ErngIllustratr_NewRep_PicUrl;
           //urlForPic = '/servlet/servlet.ImageServer?id=015Z00000009AHg&oid=00DZ00000006TPZ';
        }
        
        }catch(Exception e){
            System.Debug('\n Exception CAUGHT in EarningCalController . getPicture \n '+e);
           
        }
        
        return urlForPic;
        
    }/// End of method
    
    public String getOmniturePageName()      
    {  
        return ALMPlusUtils.generateOmniturePageName('EarningCalculatorPage', null, currUsr.Profile.Name);         
    } //this is for getting page name mapping for omniture
    
    //added by Snehashis
    public PageReference callRepDetails(){
        repDetailAcctNbr=Apexpages.currentPage().getParameters().get('repDetailAcctNbr');
        return null;
    }
    
    /**
        *  This test method is used to test
        *  the business logic of this class 
        *
        *  Created on 13 Mar, 2012
        *  Created by Raktim Sarkar
        *
    **/
    //@S-144891 : Commented by Blaine Rothrock on Nov 23
    /*public static testmethod void testEarningIllustrator()
    {
        String mktIdKey = 'XX';
        
        // Creating instance of TestDataHelper.
        TestDataHelper testData = new TestDataHelper();
        
        // Creating Market record
        Market__c mrkt = testData.createMarket();
        
        // Creating User record
        User testUsr = testData.createLeaderUser(mktIdKey);
        
        // Updating Market record with User's Id
        mrkt.OwnerId = testUsr.Id;
        update  mrkt;
        
        // Creating leder titles record.
        testData.createLeaderTitles();        
        
        EarningCalController ctlr ;
        
        System.runAs(testUsr)
        {
            ctlr = new EarningCalController();
            ctlr.loadData();
            System.assert(ctlr.lst_EstimtdErngLevel.size() == 9);
            System.assert(EarningCalController.mapEstimtdErng == null);          
            
            EarningCalController.getData(0);
            EarningCalController.getPicture(0, false);
            System.assert(ctlr.lst_EstimtdErngLevel.size() == 9);
            System.assert(EarningCalController.mapEstimtdErng.size() == 9);
            
            EarningCalController.getData(1);
            EarningCalController.getPicture(1, false);
            System.assert(ctlr.lst_EstimtdErngLevel.size() == 9);
            System.assert(EarningCalController.mapEstimtdErng.size() == 9);
            
            EarningCalController.getData(4);
            EarningCalController.getPicture(4, false);
            System.assert(ctlr.lst_EstimtdErngLevel.size() == 9);
            System.assert(EarningCalController.mapEstimtdErng.size() == 9);
                        
            EarningCalController.getData(10);
            EarningCalController.getPicture(10, false);
                       
            
        }   
        
        PageReference pageRef = Page.EarningCalculatorPage;
        pageRef.getParameters().put('repDetailAcctNbr', mktIdKey); 
        Test.setCurrentPage(pageRef);  
        
        System.runAs(testUsr)
        {
            ctlr = new EarningCalController();
            ctlr.loadData();
            
            ctlr.getOmniturePageName();
            ctlr.callRepDetails();
                
        }        
            
    }*/ // End of test method
    
    public class IllustratrException extends Exception{ }
    
}// End of Class
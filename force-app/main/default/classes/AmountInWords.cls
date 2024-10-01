Public Class AmountInWords{
    
    // Long num = 45678;
    
    public static  string amountinWords {get;set;}
    
    public static String inWords(Long num){
        Integer k, ends;
        long a ,b, c, d, f, g;
        Map<Integer,String> wordMap = new Map<Integer, String>();
        List<String> inWords = new List<String>();
        
        amountInWords = '';
        //Load the map starts here
        wordMap.put(99, 'Ninty Nine');
        wordMap.put(98, 'Ninty Eight');
        wordMap.put(97, 'Ninty Seven');
        wordMap.put(96, 'Ninty Six');
        wordMap.put(95, 'Ninty Five');
        wordMap.put(94, 'Ninty Four');
        wordMap.put(93, 'Ninty Three');
        wordMap.put(92, 'Ninty Two');
        wordMap.put(91, 'Ninty One');
        wordMap.put(90, 'Ninty');
        wordMap.put(89, 'Eighty Nine');
        
        wordMap.put(88, 'Eighty Eight');
        wordMap.put(87, 'Eighty Seven');
        wordMap.put(86, 'Eighty Six');
        wordMap.put(85, 'Eighty Five');
        wordMap.put(84, 'Eighty Four');
        wordMap.put(83, 'Eighty Three');
        wordMap.put(82, 'Eighty Two');
        wordMap.put(81, 'Eighty One');
        wordMap.put(80, 'Eighty');
        wordMap.put(79, 'Seventy Nine');
        wordMap.put(78, 'Seventy Eight');
        wordMap.put(77, 'Seventy Seven');
        wordMap.put(76, 'Seventy Six');
        wordMap.put(75, 'Seventy Five');
        wordMap.put(74, 'Seventy Four');
        wordMap.put(73, 'Seventy Three');
        wordMap.put(72, 'Seventy Two');
        wordMap.put(71, 'Seventy One');
        wordMap.put(70, 'Seventy');
        wordMap.put(69, 'Sixty Nine');
        wordMap.put(68, 'Sixty Eight');
        wordMap.put(67, 'Sixty Seven');
        
        
        wordMap.put(66, 'Sixty Six');
        wordMap.put(65, 'Sixty Five');
        wordMap.put(64, 'Sixty Four');
        wordMap.put(63, 'Sixty Three');
        wordMap.put(62, 'Sixty Two');
        wordMap.put(61, 'Sixty One');
        wordMap.put(60, 'Sixty');
        wordMap.put(59, 'Fifty Nine');
        wordMap.put(58, 'Fifty Eight');
        wordMap.put(57, 'Fifty Seven');
        wordMap.put(56, 'Fifty Six');
        
        wordMap.put(55, 'Fifty Five');
        wordMap.put(54, 'Fifty Four');
        wordMap.put(53, 'Fifty Three');
        wordMap.put(52, 'Fifty Two');
        wordMap.put(51, 'Fifty One');
        wordMap.put(50, 'Fifty');
        wordMap.put(49, 'Fourty Nine');
        wordMap.put(48, 'Fourty Eight');
        wordMap.put(47, 'Fourty Seven');
        wordMap.put(46, 'Fourty Six');
        wordMap.put(45, 'Fourty Five');
        
        wordMap.put(44, 'Fourty Four');
        wordMap.put(43, 'Fourty Three');
        wordMap.put(42, 'Fourty Two');
        wordMap.put(41, 'Fourty One');
        wordMap.put(40, 'Fourty');
        wordMap.put(39, 'Thirty Nine');
        wordMap.put(38, 'Thirty Eight');
        wordMap.put(37, 'Thirty Seven');
        wordMap.put(36, 'Thirty Six');
        wordMap.put(35, 'Thirty Five');
        wordMap.put(34, 'Thirty Four');
        
        wordMap.put(33, 'Thirty Three');
        wordMap.put(32, 'Thirty Two');
        wordMap.put(31, 'Thirty One');
        wordMap.put(30, 'Thirty');
        wordMap.put(29, 'Twenty Nine');
        wordMap.put(28, 'Twenty Eight');
        wordMap.put(27, 'Twenty Seven');
        wordMap.put(26, 'Twenty Six');
        wordMap.put(25, 'Twenty Five');
        wordMap.put(24, 'Twenty Four');
        wordMap.put(23, 'Twenty Three');
        
        wordMap.put(22, 'Twenty Two');
        wordMap.put(21, 'Twenty One');
        wordMap.put(20, 'Twenty');
        wordMap.put(19, 'Ninteen');
        wordMap.put(18, 'Eighteen');
        wordMap.put(17, 'Seventeen');
        wordMap.put(16, 'Sixtenn');
        wordMap.put(15, 'Fifteen');
        wordMap.put(14, 'Fourteen');
        wordMap.put(13, 'thirteen');
        wordMap.put(12, 'Twelve');
        
        wordMap.put(11, 'Eleven');
        wordMap.put(10, 'Ten');
        wordMap.put(9, 'Nine');
        wordMap.put(8, 'Eight');
        wordMap.put(7, 'Seven');
        wordMap.put(6, 'Six');
        wordMap.put(5, 'Five');
        wordMap.put(4, 'Four');
        wordMap.put(3, 'Three');
        wordMap.put(2, 'Two');
        wordMap.put(1, 'One');
        
        //Load the map ends here
        
        While (ends != 0){
            
            //Calculate the length of the AmountInWords
            if( num >= 9999999){
                k = 2;
            }  
            else 
                k = 1;
            String nu = num.format();
            system.debug('the value is' + nu);
            Integer len = nu.length();
            len= len - k;
            
            system.debug('the length is' + len);
            system.debug('the number is' + num);
            //Scenario 10,00,000 or 55,66,777
            if(len >= 6){
                system.debug('inside the 1st loop');
                a = num / 100000;
                system.debug('the value is a' + a); 
                
                //check mod is 0 or not
                b = Math.mod(num , 100000);
                //for scenario 55,00,000;
                if(b == 0){
                    inWords.add(wordMap.get(a.intValue()));
                    inWords.add('Lakhs');
                    ends = 0;
                }
                //for scenario 55,00,057
                else if(b < 100){
                    system.debug('word is' + wordMap.get(a.intValue()));
                    inWords.add(wordMap.get(a.intValue()));
                    inWords.add('Lakhs');
                    inWords.add(wordMap.get(b.intValue()));
                    ends = 0;
                }
                else{
                    inWords.add(wordMap.get(a.intValue()));
                    inWords.add('Lakhs');
                    num = b;
                    system.debug('some other scenario mod >=100');   
                }
            }
            
            //Scenario 99,789 or 9,789
            else if(len == 5 || len == 4){
                system.debug('inside the 2nd loop');
                c = num / 1000;
                
                //check mod is 0 or not
                d = Math.mod(num , 1000);
                //for scenario 55,000 or 5000
                if(d == 0){
                    inWords.add(wordMap.get(c.intValue()));
                    inWords.add('Thousand');
                    ends = 0;
                }
                //for scenario 55,057 or 5,057
                else if(d < 100){
                    inWords.add(wordMap.get(c.intValue()));
                    inWords.add('Thousand');
                    inWords.add(wordMap.get(d.intValue()));
                    ends = 0;
                }
                //for scenario 55,678 or 5,987
                else{
                    inWords.add(wordMap.get(c.intValue()));
                    inWords.add('Thousand');
                    num = d;
                    system.debug('some other scenario mod >=100');   
                }
            }
            else {
                system.debug('inside the 3rd loop');
                f = num / 100;
                
                //check mod is 0 or not
                g = Math.mod(num , 100);
                if(g == 0){
                    inWords.add(wordMap.get(f.intValue()));
                    inWords.add('Hundred');
                    ends = 0;
                }
                else if(g < 100){
                    inWords.add(wordMap.get(f.intValue()));
                    inWords.add('Hundred');
                    inWords.add(wordMap.get(g.intValue()));
                    ends = 0;
                }
                else{
                    num = g;
                    system.debug('some other scenario mod >=100 ');   
                }            
            }
        }
        
        inWords.add('only');
         inWords.add('\n');
        system.debug('the list is' + inWords);
        for(Integer z = 0;z<inWords.size()-1;z++){
            amountInWords = amountInWords + ' ' + string.ValueOf(inWords[z]);
            
        }
        system.debug('in words is:' + amountInWords);
        return amountInWords;
        
    }
    
}
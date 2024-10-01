public with sharing class HelperClass {
    public static Decimal getInteger(Decimal Amount) {
        if (Amount == null) {
            return Amount;
        }
        else {
            return Amount.setScale(0);
        }
    }
    }
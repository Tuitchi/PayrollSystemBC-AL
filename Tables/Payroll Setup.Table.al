table 50101 "PH Payroll Setup"
{
    Caption = 'PH Payroll Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; PrimaryKey; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; SSS_Contribution_Pct; Decimal)
        {
            Caption = 'SSS Contribution Percentage';
            MinValue = 0;
            MaxValue = 100;
            DecimalPlaces = 2;
        }
        field(3; PagIBIG_Contribution_Pct; Decimal)
        {
            Caption = 'Pag-IBIG Contribution Percentage';
            MinValue = 0;
            MaxValue = 100;
            DecimalPlaces = 2;
        }
        field(4; PhilHealth_Contribution_Pct; Decimal)
        {
            Caption = 'PhilHealth Contribution Percentage';
            MinValue = 0;
            MaxValue = 100;
            DecimalPlaces = 2;
        }
        field(5; Default_Working_Hours; Decimal)
        {
            Caption = 'Default Working Hours Per Day';
            MinValue = 0;
            DecimalPlaces = 2;
        }
        field(6; Default_Working_Days; Integer)
        {
            Caption = 'Default Working Days Per Month';
            MinValue = 0;
        }
        field(7; Tax_Bracket1_Max; Decimal)
        {
            Caption = 'Tax Bracket 1 Max';
            DecimalPlaces = 2;
        }
        field(8; Tax_Rate1; Decimal)
        {
            Caption = 'Tax Rate 1';
            MinValue = 0;
            MaxValue = 100;
            DecimalPlaces = 2;
        }
        field(9; Tax_Bracket2_Max; Decimal)
        {
            Caption = 'Tax Bracket 2 Max';
            DecimalPlaces = 2;
        }
        field(10; Tax_Rate2; Decimal)
        {
            Caption = 'Tax Rate 2';
            MinValue = 0;
            MaxValue = 100;
            DecimalPlaces = 2;
        }
        field(11; Tax_Bracket3_Max; Decimal)
        {
            Caption = 'Tax Bracket 3 Max';
            DecimalPlaces = 2;
        }
        field(12; Tax_Rate3; Decimal)
        {
            Caption = 'Tax Rate 3';
            MinValue = 0;
            MaxValue = 100;
            DecimalPlaces = 2;
        }
        field(13; Tax_Bracket4_Max; Decimal)
        {
            Caption = 'Tax Bracket 4 Max';
            DecimalPlaces = 2;
        }
        field(14; Tax_Rate4; Decimal)
        {
            Caption = 'Tax Rate 4';
            MinValue = 0;
            MaxValue = 100;
            DecimalPlaces = 2;
        }
        field(15; Tax_Rate5; Decimal)
        {
            Caption = 'Tax Rate 5';
            MinValue = 0;
            MaxValue = 100;
            DecimalPlaces = 2;
        }
    }

    keys
    {
        key(PK; PrimaryKey)
        {
            Clustered = true;
        }
    }
}
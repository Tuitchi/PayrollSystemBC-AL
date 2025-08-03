table 50101 "PH Payroll Setup"
{
    Caption = 'PH Payroll Setup';
    DataClassification = ToBeClassified;
    ObsoleteState = Pending;
    ObsoleteReason = 'Table will be removed in a future release';

    fields
    {
        field(1; PrimaryKey; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Setup Name"; Text[50])
        {
            Caption = 'Setup Name';
        }
        field(3; "Setup Value"; Text[100])
        {
            Caption = 'Setup Value';
        }
        field(4; SSS_Contribution_Pct; Decimal)
        {
            Caption = 'SSS Contribution Percentage';
            ObsoleteState = Pending;
            ObsoleteReason = 'Field will be removed in a future release';
        }
        field(5; PagIBIG_Contribution_Pct; Decimal)
        {
            Caption = 'PagIBIG Contribution Percentage';
            ObsoleteState = Pending;
            ObsoleteReason = 'Field will be removed in a future release';
        }
        field(6; PhilHealth_Contribution_Pct; Decimal)
        {
            Caption = 'PhilHealth Contribution Percentage';
            ObsoleteState = Pending;
            ObsoleteReason = 'Field will be removed in a future release';
        }
        field(7; Default_Working_Hours; Decimal)
        {
            Caption = 'Default Working Hours';
            ObsoleteState = Pending;
            ObsoleteReason = 'Field will be removed in a future release';
        }
        field(8; Default_Working_Days; Decimal)
        {
            Caption = 'Default Working Days';
            ObsoleteState = Pending;
            ObsoleteReason = 'Field will be removed in a future release';
        }
        field(9; Tax_Bracket1_Max; Decimal)
        {
            Caption = 'Tax Bracket 1 Maximum';
            ObsoleteState = Pending;
            ObsoleteReason = 'Field will be removed in a future release';
        }
        field(10; Tax_Rate1; Decimal)
        {
            Caption = 'Tax Rate 1';
            ObsoleteState = Pending;
            ObsoleteReason = 'Field will be removed in a future release';
        }
        field(11; Tax_Bracket2_Max; Decimal)
        {
            Caption = 'Tax Bracket 2 Maximum';
            ObsoleteState = Pending;
            ObsoleteReason = 'Field will be removed in a future release';
        }
        field(12; Tax_Rate2; Decimal)
        {
            Caption = 'Tax Rate 2';
            ObsoleteState = Pending;
            ObsoleteReason = 'Field will be removed in a future release';
        }
        field(13; Tax_Bracket3_Max; Decimal)
        {
            Caption = 'Tax Bracket 3 Maximum';
            ObsoleteState = Pending;
            ObsoleteReason = 'Field will be removed in a future release';
        }
        field(14; Tax_Rate3; Decimal)
        {
            Caption = 'Tax Rate 3';
            ObsoleteState = Pending;
            ObsoleteReason = 'Field will be removed in a future release';
        }
        field(15; Tax_Bracket4_Max; Decimal)
        {
            Caption = 'Tax Bracket 4 Maximum';
            ObsoleteState = Pending;
            ObsoleteReason = 'Field will be removed in a future release';
        }
        field(16; Tax_Rate4; Decimal)
        {
            Caption = 'Tax Rate 4';
            ObsoleteState = Pending;
            ObsoleteReason = 'Field will be removed in a future release';
        }
        field(17; Tax_Rate5; Decimal)
        {
            Caption = 'Tax Rate 5';
            ObsoleteState = Pending;
            ObsoleteReason = 'Field will be removed in a future release';
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
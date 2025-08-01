table 50107 "Pag-IBIG Contribution"
{
    DataClassification = ToBeClassified;
    Caption = 'Pag-IBIG Contribution Table';

    fields
    {
        field(1; "Entry No."; Code[20])
        {
            Caption = 'Entry No.';
        }
        field(2; "Minimum Salary"; Decimal)
        {
            Caption = 'Minimum Salary';
        }
        field(3; "Maximum Salary"; Decimal)
        {
            Caption = 'Maximum Salary';
        }
        field(4; "Employee Share Pct"; Decimal)
        {
            Caption = 'Employee Share %';
            DecimalPlaces = 2;
        }
        field(5; "Employer Share Pct"; Decimal)
        {
            Caption = 'Employer Share %';
            DecimalPlaces = 2;
        }
        field(6; "Total Contribution"; Decimal)
        {
            Caption = 'Total Contribution';
            DecimalPlaces = 2;
        }
        field(7; "Effective Date"; Date)
        {
            Caption = 'Effective Date';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(SalaryRange; "Minimum Salary", "Maximum Salary", "Effective Date")
        {
        }
    }
}
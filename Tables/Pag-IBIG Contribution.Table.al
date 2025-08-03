table 50107 "Pag-IBIG Contribution"
{
    Caption = 'Pag-IBIG Contribution';
    DataClassification = ToBeClassified;
    ObsoleteState = Pending;
    ObsoleteReason = 'Table will be removed in a future release';

    fields
    {
        field(1; "Entry No."; Code[20])
        {
            Caption = 'Entry No.';
        }
        field(2; "Low Rate"; Decimal)
        {
            Caption = 'Low Rate';
        }
        field(3; "High Rate"; Decimal)
        {
            Caption = 'High Rate';
        }
        field(4; "Employee Share"; Decimal)
        {
            Caption = 'Employee Share';
        }
        field(5; "Employer Share"; Decimal)
        {
            Caption = 'Employer Share';
        }
        field(6; "Effective Date"; Date)
        {
            Caption = 'Effective Date';
        }
        field(7; "Minimum Salary"; Decimal)
        {
            Caption = 'Minimum Salary';
            ObsoleteState = Pending;
            ObsoleteReason = 'Field will be removed in a future release';
        }
        field(8; "Maximum Salary"; Decimal)
        {
            Caption = 'Maximum Salary';
            ObsoleteState = Pending;
            ObsoleteReason = 'Field will be removed in a future release';
        }
        field(9; "Employee Share Pct"; Decimal)
        {
            Caption = 'Employee Share Percentage';
            ObsoleteState = Pending;
            ObsoleteReason = 'Field will be removed in a future release';
        }
        field(10; "Employer Share Pct"; Decimal)
        {
            Caption = 'Employer Share Percentage';
            ObsoleteState = Pending;
            ObsoleteReason = 'Field will be removed in a future release';
        }
        field(11; "Total Contribution"; Decimal)
        {
            Caption = 'Total Contribution';
            ObsoleteState = Pending;
            ObsoleteReason = 'Field will be removed in a future release';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
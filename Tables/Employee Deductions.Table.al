table 50113 "Employee Deductions"
{
    Caption = 'Employee Deductions';
    DataClassification = ToBeClassified;
    ObsoleteState = Pending;
    ObsoleteReason = 'Table will be removed in a future release';

    fields
    {
        field(1; "Entry No."; Code[20])
        {
            Caption = 'Entry No.';
        }
        field(2; "Employee ID"; Code[20])
        {
            Caption = 'Employee ID';
        }
        field(3; "Deduction Type"; Option)
        {
            Caption = 'Deduction Type';
            OptionMembers = Loan,Advance,Other;
            OptionCaption = 'Loan,Advance,Other';
        }
        field(4; "Deduction Amount"; Decimal)
        {
            Caption = 'Deduction Amount';
        }
        field(5; "Effective Date"; Date)
        {
            Caption = 'Effective Date';
        }
        field(6; "Description"; Text[100])
        {
            Caption = 'Description';
        }
        field(7; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
        }
        field(8; "Start Date"; Date)
        {
            Caption = 'Start Date';
        }
        field(9; "End Date"; Date)
        {
            Caption = 'End Date';
        }
        field(10; "Amount"; Decimal)
        {
            Caption = 'Amount';
        }
        field(11; "Remaining Amount"; Decimal)
        {
            Caption = 'Remaining Amount';
        }
        field(12; "Status"; Option)
        {
            Caption = 'Status';
            OptionMembers = Active,Inactive,Completed;
            OptionCaption = 'Active,Inactive,Completed';
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
table 50113 "Employee Deductions"
{
    DataClassification = ToBeClassified;
    Caption = 'Employee Deductions';

    fields
    {
        field(1; "Entry No."; Code[20])
        {
            Caption = 'Entry No.';
        }
        field(2; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = Employee."No.";
        }
        field(3; "Deduction Type"; Option)
        {
            Caption = 'Deduction Type';
            OptionMembers = Loan,Advance,"Other Deduction";
            OptionCaption = 'Loan,Advance,Other Deduction';
        }
        field(4; "Description"; Text[100])
        {
            Caption = 'Description';
        }
        field(5; "Start Date"; Date)
        {
            Caption = 'Start Date';
        }
        field(6; "End Date"; Date)
        {
            Caption = 'End Date';
        }
        field(7; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DecimalPlaces = 2;
            MinValue = 0;
        }
        field(8; "Remaining Amount"; Decimal)
        {
            Caption = 'Remaining Amount';
            DecimalPlaces = 2;
            MinValue = 0;
        }
        field(9; "Status"; Option)
        {
            Caption = 'Status';
            OptionMembers = Active,Completed,Cancelled;
            OptionCaption = 'Active,Completed,Cancelled';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(EmployeeKey; "Employee No.", "Deduction Type", "Start Date")
        {
        }
    }
}
table 50111 "Shift Assignment"
{
    DataClassification = ToBeClassified;
    Caption = 'Shift Assignment';

    fields
    {
        field(1; "Shift Assignment No."; Integer)
        {
            Caption = 'Shift Assignment No.';
            AutoIncrement = true;
        }
        field(2; "Employee ID"; Code[20])
        {
            Caption = 'Employee ID';
            TableRelation = Employee."No." where("No." = field("Employee ID"));
        }
        field(3; "Shift Code"; Code[10])
        {
            Caption = 'Shift Code';
            TableRelation = Shift."Shift Code" where("Is Active" = const(true));
        }
        field(4; "Effective Date"; Date)
        {
            Caption = 'Effective Date';
        }
        field(5; "End Date"; Date)
        {
            Caption = 'End Date';
        }
        field(6; "Is Active"; Boolean)
        {
            Caption = 'Is Active';
        }
        field(7; "Created Date"; Date)
        {
            Caption = 'Created Date';
        }
        field(8; "Created By"; Code[50])
        {
            Caption = 'Created By';
        }
    }

    keys
    {
        key(PK; "Shift Assignment No.")
        {
            Clustered = true;
        }
        key(EmployeeShift; "Employee ID", "Shift Code", "Effective Date")
        {
        }
        key(ActiveAssignment; "Employee ID", "Is Active")
        {
        }
    }
}
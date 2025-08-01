table 50105 "Daily Time Record"
{
    DataClassification = ToBeClassified;
    Caption = 'Daily Time Record';

    fields
    {
        field(1; "Entry No."; Code[20])
        {
            Caption = 'Entry No.';
        }
        field(2; "EmployeeId"; Code[20])
        {
            Caption = 'Employee ID';
            TableRelation = Employee."No." where("No." = field(EmployeeId));

            trigger OnLookup()
            var
                Employee: Record Employee;
                EmployeeList: Page "Employee List";
            begin
                EmployeeList.LookupMode(true);
                if EmployeeList.RunModal() = Action::LookupOK then begin
                    EmployeeList.GetRecord(Employee);
                    Rec.EmployeeId := Employee."No.";
                end;
            end;
        }

        field(3; "Date"; Date)
        {
            Caption = 'Date';
        }
        field(4; "TimeIn"; Time)
        {
            Caption = 'Time In';
        }
        field(5; "TimeOut"; Time)
        {
            Caption = 'Time Out';
        }
        field(6; "OTHour"; Decimal)
        {
            Caption = 'OT Hours';
            DecimalPlaces = 2;
        }
        field(7; "OTapprove"; Boolean)
        {
            Caption = 'OT Approved';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(EmployeeDate; "EmployeeId", "Date")
        {
        }
    }
}
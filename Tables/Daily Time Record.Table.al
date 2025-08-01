table 50105 "Daily Time Record"
{
    DataClassification = ToBeClassified;
    Caption = 'Daily Time Record';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "EmployeeId"; Code[20])
        {
            Caption = 'Employee ID';
            TableRelation = "Employee Data".EmployeeId;
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
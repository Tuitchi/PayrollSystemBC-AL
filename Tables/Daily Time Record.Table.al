table 50105 "Daily Time Record"
{
    DataClassification = ToBeClassified;
    Caption = 'Daily Time Record';

    fields
    {
        field(1; "DTR No."; Code[20])
        {
            Caption = 'DTR No.';
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

            trigger OnValidate()
            begin
                FetchShiftInformation();
            end;
        }

        field(3; "Date"; Date)
        {
            Caption = 'Date';

            trigger OnValidate()
            begin
                FetchShiftInformation();
            end;
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
        field(8; "Shift Code"; Code[10])
        {
            Caption = 'Shift Code';
            TableRelation = Shift."Shift Code" where("Is Active" = const(true));
        }
        field(9; "Expected Time In"; Time)
        {
            Caption = 'Expected Time In';
        }
        field(10; "Expected Time Out"; Time)
        {
            Caption = 'Expected Time Out';
        }
        field(11; "Status"; Option)
        {
            Caption = 'Status';
            OptionMembers = Present,Absent,Late,Early,"On Leave";
            OptionCaption = 'Present,Absent,Late,Early,On Leave';
        }
        field(12; "Remarks"; Text[100])
        {
            Caption = 'Remarks';
        }
    }

    keys
    {
        key(PK; "DTR No.")
        {
            Clustered = true;
        }
        key(EmployeeDate; "EmployeeId", "Date")
        {
        }
    }

    trigger OnInsert()
    begin
        FetchShiftInformation();
    end;

    trigger OnModify()
    begin
        FetchShiftInformation();
    end;

    local procedure FetchShiftInformation()
    var
        ShiftAssignment: Record "Shift Assignment";
        Shift: Record Shift;
    begin
        if (Rec."EmployeeId" = '') or (Rec."Date" = 0D) then
            exit;

        // Get employee's assigned shift for the DTR date
        ShiftAssignment.Reset();
        ShiftAssignment.SetRange("Employee ID", Rec."EmployeeId");
        ShiftAssignment.SetRange("Is Active", true);
        ShiftAssignment.SetFilter("Effective Date", '<=%1', Rec."Date");
        if ShiftAssignment."End Date" <> 0D then
            ShiftAssignment.SetFilter("End Date", '>=%1', Rec."Date");
        ShiftAssignment.SetCurrentKey("Effective Date");
        ShiftAssignment.SetAscending("Effective Date", false);

        if ShiftAssignment.FindFirst() then begin
            // Get shift details
            Shift.Reset();
            Shift.SetRange("Shift Code", ShiftAssignment."Shift Code");
            if Shift.FindFirst() then begin
                Rec."Shift Code" := Shift."Shift Code";
                Rec."Expected Time In" := Shift."Start Time";
                Rec."Expected Time Out" := Shift."End Time";
            end;
        end;
    end;
}
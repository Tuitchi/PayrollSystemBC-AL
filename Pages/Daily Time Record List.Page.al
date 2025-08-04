page 50107 "Daily Time Record List"
{
    ApplicationArea = All;
    Caption = 'Daily Time Records';
    PageType = List;
    SourceTable = "Daily Time Record";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("DTR No."; Rec."DTR No.")
                {
                    ToolTip = 'Specifies the DTR number.';
                    Editable = false;
                }
                field("EmployeeId"; Rec."EmployeeId")
                {
                    ToolTip = 'Specifies the Employee ID.';
                    Editable = false;
                }
                field("EmployeeName"; EmployeeName)
                {
                    Caption = 'Employee Name';
                    ToolTip = 'Specifies the full name of the employee.';
                    Editable = false;
                }
                field("Date"; Rec."Date")
                {
                    ToolTip = 'Specifies the attendance date.';
                }
                field("Shift Code"; Rec."Shift Code")
                {
                    ToolTip = 'Specifies the assigned shift.';
                    Editable = false;
                }
                field("Expected Time In"; Rec."Expected Time In")
                {
                    ToolTip = 'Specifies the expected time in based on shift.';
                    Editable = false;
                }
                field("Expected Time Out"; Rec."Expected Time Out")
                {
                    ToolTip = 'Specifies the expected time out based on shift.';
                    Editable = false;
                }
                field("TimeIn"; Rec."TimeIn")
                {
                    ToolTip = 'Specifies the time in.';
                }
                field("TimeOut"; Rec."TimeOut")
                {
                    ToolTip = 'Specifies the time out.';
                }
                field("OTHour"; Rec."OTHour")
                {
                    ToolTip = 'Specifies the overtime hours.';
                }
                field("OTapprove"; Rec."OTapprove")
                {
                    ToolTip = 'Specifies if overtime is approved.';
                }
                field("Status"; Rec."Status")
                {
                    ToolTip = 'Specifies the attendance status.';
                }
                field("Remarks"; Rec."Remarks")
                {
                    ToolTip = 'Specifies any remarks.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(AutoAssignShift)
            {
                ApplicationArea = All;
                Caption = 'Auto Assign Shift';
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Automatically assign shift codes and expected times based on employee shift assignments.';

                trigger OnAction()
                var
                    DTR: Record "Daily Time Record";
                    ShiftAssignment: Record "Shift Assignment";
                    Shift: Record Shift;
                    UpdatedCount: Integer;
                begin
                    UpdatedCount := 0;
                    if DTR.FindSet() then
                        repeat
                            // Get employee's assigned shift for the DTR date
                            ShiftAssignment.Reset();
                            ShiftAssignment.SetRange("Employee ID", DTR."EmployeeId");
                            ShiftAssignment.SetRange("Is Active", true);
                            ShiftAssignment.SetFilter("Effective Date", '<=%1', DTR."Date");
                            if ShiftAssignment."End Date" <> 0D then
                                ShiftAssignment.SetFilter("End Date", '>=%1', DTR."Date");
                            ShiftAssignment.SetCurrentKey("Effective Date");
                            ShiftAssignment.SetAscending("Effective Date", false);

                            if ShiftAssignment.FindFirst() then begin
                                // Get shift details
                                Shift.Reset();
                                Shift.SetRange("Shift Code", ShiftAssignment."Shift Code");
                                if Shift.FindFirst() then begin
                                    DTR."Shift Code" := Shift."Shift Code";
                                    DTR."Expected Time In" := Shift."Start Time";
                                    DTR."Expected Time Out" := Shift."End Time";
                                    DTR.Modify();
                                    UpdatedCount += 1;
                                end;
                            end;
                        until DTR.Next() = 0;

                    Message('Shift codes and expected times assigned to %1 DTR records.', UpdatedCount);
                end;
            }
        }
    }

    var
        EmployeeName: Text;

    trigger OnAfterGetRecord()
    var
        EmployeeRec: Record Employee;
    begin
        EmployeeName := '';
        if EmployeeRec.Get(Rec."EmployeeId") then
            EmployeeName := EmployeeRec."First Name" + ' ' + EmployeeRec."Last Name";
    end;
}
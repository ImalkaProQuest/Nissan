<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Lead_Status_Change_Date</fullName>
        <field>Date_Status_Changed__c</field>
        <formula>DATEVALUE(LastModifiedDate)</formula>
        <name>Lead Status Change Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Send Notification on Lead Ready to Convert</fullName>
        <actions>
            <name>Lead_Ready_to_Convert</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Ready_to_Convert__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Create task as a reminder to convert lead</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Status Change Date</fullName>
        <actions>
            <name>Lead_Status_Change_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(ISNEW(),ISCHANGED( Status ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>Lead_Ready_to_Convert</fullName>
        <assignedTo>Data_Administrator</assignedTo>
        <assignedToType>role</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Lead Ready to Convert</subject>
    </tasks>
</Workflow>

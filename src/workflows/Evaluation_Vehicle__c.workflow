<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UPD_EVV01_Live_Start_date</fullName>
        <field>Live_Start_date__c</field>
        <formula>NOW()</formula>
        <name>UPD_EVV01 Live Start date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UPD_EVV02_Live_End_date</fullName>
        <field>Live_End_date__c</field>
        <formula>NOW()</formula>
        <name>UPD_EVV02 Live End date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UPD_EVV03_TECH_Model</fullName>
        <description>This field is populated with Model value for search purpose</description>
        <field>TECH_Model__c</field>
        <formula>Model__c</formula>
        <name>UPD_EVV03_TECH_Model</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>WF_EVV01_Update Live Start Date</fullName>
        <actions>
            <name>UPD_EVV01_Live_Start_date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>(ISNEW() &amp;&amp;  ISPICKVAL( Status__c, &quot;Live&quot;  ))   ||  (ISCHANGED(Status__c) &amp;&amp; ISPICKVAL(Status__c, &quot;Live&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WF_EVV02_Update Live End Date</fullName>
        <actions>
            <name>UPD_EVV02_Live_End_date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status__c) &amp;&amp;  ISPICKVAL(Status__c, &quot;Grounded&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WF_EVV03_Update_Tech_Model</fullName>
        <actions>
            <name>UPD_EVV03_TECH_Model</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Evaluation_Vehicle__c.TECH_Model__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>

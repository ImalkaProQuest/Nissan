<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Expired_Dealer_RT_Update</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Expired_Dealer</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Expired Dealer RT Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Expired_FMO_Organisation_RT_Update</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Expired_FMO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Expired FMO Organisation RT Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Expired_Organisation_RT_Update</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Expired_Organisation</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Expired Organisation RT Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_Expired_Direct</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Expired_Direct</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type Expired Direct</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Record Type Expired Dealer</fullName>
        <actions>
            <name>Expired_Dealer_RT_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>RecordType.Name = &apos;Dealer&apos; &amp;&amp; ISPICKVAL(Status__c, &apos;CEASED TRADING&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Record Type Expired Direct Organisation</fullName>
        <actions>
            <name>Update_Record_Type_Expired_Direct</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>RecordType.Name = &apos;Direct&apos; &amp;&amp; ISPICKVAL(Status__c, &apos;CEASED TRADING&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Record Type Expired FMO</fullName>
        <actions>
            <name>Expired_FMO_Organisation_RT_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>RecordType.Name = &apos;FMO Organisation&apos; &amp;&amp; ISPICKVAL(Status__c, &apos;Expired&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Record Type Expired Organisation</fullName>
        <actions>
            <name>Expired_Organisation_RT_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>RecordType.Name = &apos;Organisation&apos; &amp;&amp; ISPICKVAL(Status__c, &apos;Expired&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>

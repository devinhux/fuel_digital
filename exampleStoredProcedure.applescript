USE [8269_Uustal]
GO
/****** Object:  StoredProcedure [trialworks].[usp_insert_staging_Pleadings]    Script Date: 8/5/2021 7:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
ALTER PROCEDURE
	[trialworks].[usp_insert_staging_Pleadings]
		  @DebugFlag BIT
		, @Database VARCHAR(1000)
		, @SchemaName VARCHAR(1000)
		, @FVProductionPrefix VARCHAR(1000)
		, @timezone VARCHAR(1000)
AS
	BEGIN 
		SELECT 
			'Devin scripted 100%?, multiple links for docs field'

		
		/*================================================================================================*/
		/*INSERT FOR PROJECT TEMPLATE: _RILPersonalInjuryMas_ */
		/*================================================================================================*/
	
		INSERT INTO
			[PT1].[RILPersonalInjuryMas_CL_Pleadings]
			(
				  [__ImportStatus]
				, [__ImportStatusDate]
				, [__ErrorMessage]
				, [__WorkerID]
				, [__CollectionItemGuid]
				, [ProjectExternalID]
				, [CollectionItemExternalID]
				, [pleadingtype]
				, [dateserved]
				, [ordertendered]
				, [notes]
				, [documentsDocExternalIdCsv]
				, [pleadingname]
				, [drafterContactExternalID]
				, [motionsDocExternalIdCsv]
				, [copyoforderDocExternalIdCsv]
				, [trialcourtreporterContactExternalID]
				, [courtOrderedDeadline]
				, [courtOrderedDeadlineDueDueDate]
				, [courtOrderedDeadlineDueDoneDate]
				, [trialOrder]
				, [hearingRequired]
				, [otherPartyContactExternalID]
				, [authorContactExternalID]
				, [otherPartyAttorneyContactExternalID]
				
			)
		SELECT DISTINCT
			  40 [__ImportStatus]
			, GETDATE() [__ImportStatusDate]
			, NULL [__ErrorMessage]
			, NULL [__WorkerID]
			, NULL [__CollectionItemGuid]
			, ccm.ProjectExternalID [ProjectExternalID]
			,  CONCAT_WS('_', 'PLEADINGS', ccm.ProjectExternalID, pleading.PleadingID) [CollectionItemExternalID]
			, CASE
					WHEN temps.Category in ('Complaint') then 'Complaint'
					WHEN temps.Category in ('Motion') then 'Motion'
					WHEN temps.Category in ('Notice') then 'Notice'
					WHEN temps.Category in ('Orders') then 'Order'
					WHEN temps.Category in ('Stips') then 'Stip'
					WHEN temps.Category in ('TOB') then 'TOB'
				END [pleadingtype] --not sure what the name of the file has to do with this field - Pleadings Template.Category
			, NULL [dateserved]
			, NULL [ordertendered]
			, pleading.Notes [notes]
			, NULL [documentsDocExternalIdCsv] --not sure Pleadings.link, Link2
			, SUBSTRING(pleading.link, 1, CHARINDEX('#', pleading.link) - 1) [pleadingname]
			, drafter.ContactExternalID [drafterContactExternalID]
			, NULL [motionsDocExternalIdCsv]
			, NULL [copyoforderDocExternalIdCsv]
			, NULL [trialcourtreporterContactExternalID]
			, NULL [courtOrderedDeadline]
			, NULL [courtOrderedDeadlineDueDueDate]
			, NULL [courtOrderedDeadlineDueDoneDate]
			, NULL [trialOrder]
			, NULL [hearingRequired] --no mapping
			, NULL [otherPartyContactExternalID] --not in map
			, NULL [authorContactExternalID] -- not in map
			, NULL [otherPartyAttorneyContactExternalID] --not in map
			
		
		FROM 
			__FV_ClientCaseMap ccm


		LEFT JOIN Pleadings pleading ON pleading.CaseId = ccm.CaseID
		LEFT JOIN [Pleadings Template] temps ON pleading.Form = temps.[File]
		left join pt1.Contacts drafter on CONCAT_WS('_','DRAFTER',LEFT(pleading.Author,200)) = drafter.ContactExternalID

		
				


	END
							
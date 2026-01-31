/* add track */
CREATE PROCEDURE SP_TrainingManager_AddTrack
    @TrackName NVARCHAR(100)
AS
BEGIN
    BEGIN TRY
        -- Removed track_description as it does not exist in your table
        INSERT INTO [Track] (track_name) 
        VALUES (@TrackName);
        
        PRINT 'Track added successfully.';
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO 
/* update */
CREATE PROCEDURE SP_TrainingManager_UpdateTrack
    @TrackId INT,
    @NewTrackName NVARCHAR(100)
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM [Track] WHERE track_id = @TrackId)
        BEGIN
            RAISERROR('Error: Track ID does not exist.', 16, 1);
            RETURN;
        END

        UPDATE [Track]
        SET track_name = @NewTrackName
        WHERE track_id = @TrackId;

        PRINT 'Track updated successfully.';
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO

/* delete */
CREATE PROCEDURE SP_TrainingManager_DeleteTrack
    @TrackId INT
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM [Track] WHERE track_id = @TrackId)
        BEGIN
            RAISERROR('Error: Track ID does not exist.', 16, 1);
            RETURN;
        END

        IF EXISTS (SELECT 1 FROM [Student] WHERE track_id = @TrackId)
        BEGIN
            RAISERROR('Error: Cannot delete track; students are assigned to it.', 16, 1);
            RETURN;
        END

        DELETE FROM [Track] WHERE track_id = @TrackId;
        PRINT 'Track deleted successfully.';
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO
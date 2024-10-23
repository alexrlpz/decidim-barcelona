# frozen_string_literal: true

Rails.application.config.to_prepare do
  Decidim::PaginateHelper.include(Decidim::PaginateHelperOverride)
  Decidim::Initiatives::Admin::Permissions.prepend(Decidim::Initiatives::Admin::PermissionsOverride)
  Decidim::SearchResourceFieldsMapper.prepend(Decidim::Overrides::SearchResourceFieldsMapper)
  Decidim::Initiatives::InitiativeMetadataGCell.include(Decidim::Initiatives::InitiativeMetadataGCellOverride)
  Decidim::Forms::UserAnswersSerializer.prepend(Decidim::Overrides::Forms::UserAnswersSerializer)
  Decidim::Initiative.include(Decidim::InitiativeOverride)
  Decidim::Accountability::Result.include(Decidim::Accountability::ResultOverride)
  Decidim::Accountability::ResultsCalculator.include(Decidim::Accountability::ResultsCalculatorOverride)
  Decidim::Accountability::StatusCell.include(Decidim::Accountability::StatusCellOverride)
  Decidim::Meetings::Meeting.include(Decidim::Meetings::MeetingOverride)
  Decidim::Meetings::MeetingsController.include(Decidim::Meetings::MeetingsControllerOverride)
  Decidim::Meetings::OnlineMeetingCell.include(Decidim::Meetings::OnlineMeetingCellOverride)
  Decidim::Meetings::MeetingsHelper.include(Decidim::Meetings::MeetingsHelperOverride)
  Decidim::Meetings::JoinMeetingButtonCell.include(Decidim::Meetings::JoinMeetingButtonCellOverride)
  Decidim::ContentBlocks::LastActivityCell.include(Decidim::ContentBlocks::LastActivityCellOverride)
  Decidim::ActivitiesCell.include(Decidim::ActivitiesCellOverride)
  Decidim::UserProfileCell.include(Decidim::UserProfileCellOverride)
  Decidim::Proposals::ProposalPresenter.include(Decidim::Proposals::ProposalPresenterOverride)
  Decidim::Forms::QuestionnaireUserAnswers.include(Decidim::Forms::QuestionnaireUserAnswersOverride)
  Decidim::Proposals::ApplicationHelper.include(Decidim::Proposals::ApplicationHelperOverride)
  Decidim::Assemblies::AssembliesController.include(Decidim::Assemblies::AssembliesControllerOverride)
end

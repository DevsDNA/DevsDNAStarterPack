namespace IoTMM.App.Features.Main
{
    using ReactiveUI;
    using System;
    using System.Reactive.Linq;
    using System.Threading.Tasks;
    using Xamarin.Forms;

    public partial class MainView
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="MainView"/> class.
        /// </summary>
        public MainView()
        {
            InitializeComponent();
            NavigationPage.SetHasNavigationBar(this, false);
        }

        protected override void OnAppearing()
        {
            base.OnAppearing();

			AdaptToCurrentDeviceType();

			BtnNewTest.TranslationY = 110;
			BtnNewTest.TranslateTo(0, 0, 500, Easing.CubicIn);
			BtnNewTest.FadeTo(1, 500, Easing.CubicIn);
		}

        protected override void CreateBindings()
        {
            base.CreateBindings();

            this.OneWayBind(ViewModel, vm => vm.StartNewAssessmentCommand, v => v.BtnNewTest.Command);
			this.OneWayBind(ViewModel, vm => vm.AssessmentsGrouped, v => v.LstAssessments.ItemsSource);


			this.WhenAny(x => x.ViewModel.AssessmentsGrouped.Count, x => x.Value).Subscribe(x => 
			{
				LstAssessments.IsVisible = x > 0;
				ImgNewTest.IsVisible = x == 0;
				LblSummaryMiddle.IsVisible = x == 0;
				if (x == 0)
					AnimateNoItemsEntry();
			});
		}

        private void AdaptToCurrentDeviceType()
        {
            switch (Device.Idiom)
            {
                case TargetIdiom.Phone:
                    ImgNewTest.WidthRequest = (this.Width / 2) * 0.6;
                    break;
            }
		}

		private async Task AnimateNoItemsEntry()
		{
			ImgNewTest.FadeTo(1, 200, Easing.CubicIn);
			await LblSummaryMiddle.FadeTo(1, 200, Easing.CubicIn);
		}
    }
}
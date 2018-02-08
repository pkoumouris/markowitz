class SecurityTopRight extends React.Component {
	constructor(props){
		super(props);
		this.state = {
			data: {
				ticker: "",
				name: "",
				description: "",
				price: 0.0,
				expret: 0.0,
				stddev: 0.0,
				lastDividend: 0.0,
				divYield: 0.0,
				numShares: 0,
				mktCorrelation: 0.0,
				historyDay: [{}],
				historyWeek: [{}],
				historyMonth: [{}],
				historyYear: [{}]
			},
			loaded: false
		};
	}

	componentDidMount() {
		let URL = `http://localhost:3000/api/securitys/${this.props.id}`;
		let component = this;

		fetch(URL)
		.then( (response) => {
			if (response.ok){
				return response.json();
			}
			throw new Error('Request fail');
		})
		.then( json => {
			component.setState({
				data: json,
				loaded: true
			});
		});
	}

	

	render(){

		let dayChange = this.state.data.historyMonth[0].price - this.state.data.price;

		let dayPercentChange = 100.0 * dayChange / this.state.data.historyMonth[0].price;

		if (dayChange > 0){
			upDay = true;
		} else {
			upDay = false;
		}

		return(
			<div id="securityTopRightComponent">
				<h3>
					{this.state.data.ticker}
				</h3>
				<h2>
					{this.state.loaded ? 
					'$'+commaDecimal(this.state.data.price) :
					"Loading..."}

					<span class={
						upDay ? "changeUp" : "changeDown"
					}>

						<span class={
							upDay ?
							"glyphicon glyphicon-arrow-up" :
							(this.state.loaded ? "glyphicon glyphicon-arrow-down" : "")
						}></span>

						{this.state.loaded ? ' '+commaDecimal(Math.abs(dayPercentChange))+'%' : ''}

						{this.state.loaded ? ' $'+commaDecimal(Math.abs(dayChange))+' ': ""}
						
					</span>

				</h2>

				<table>
					<tr>
						<td>
							Expected return
						</td>
						<td><b>
							{commaDecimal(100.0*this.state.data.expret)+'%'}
						</b></td>
					</tr>
					<tr>
						<td>
							Std deviation
						</td>
						<td><b>
							{commaDecimal(100.0*this.state.data.stddev)+'%'}
						</b></td>
					</tr>
					<tr>
						<td>
							Idiosyncratic risk*
						</td>
						<td><b>
							{commaDecimal(100.0*this.state.data.stddev)+'%'}
						</b></td>
					</tr>
					<tr>
						<td>
							Systematic risk
						</td>
						<td><b>
							{commaDecimal(100.0*this.state.data.stddev)+'%'}
						</b></td>
					</tr>
				</table>

				<h5>Change time period</h5>

					<table class="changeTimePeriod">

						<tr>



							<button type="button" class="btn btn-primary btn-xs" onClick={this.seeIntraday}>
								<span class="intraToggle">
									Intraday
								</span>
							</button>

						

							<button type="button" class="btn btn-primary btn-xs" onClick={this.seeIntraweek}>
								<span class="intraToggle">
									Intraweek
								</span>
							</button>



						</tr>
						<tr>



							<button type="button" class="btn btn-primary btn-xs" onClick={this.seeIntramonth}>
								<span class="intraToggle">
									Intramonth
								</span>
							</button>

						

							<button type="button" class="btn btn-primary btn-xs" onClick={this.seeIntrayear}>
								<span class="intraToggle">
									Intrayear
								</span>
							</button>


						</tr>

					</table>
				
			</div>
		);
	}
}
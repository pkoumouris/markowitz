class AccountViewTop extends React.Component {
	constructor(props){
		super(props);
		this.state = {
			data: {
				value: 0.0,
				cash: 0.0,
				historyDay: [{}],
				historyWeek: [{}],
				historyMonth: [{}],
				historyYear: [{}],
				expRet: 0.0,
				stdDev: 0.0,
				mktCorr: 0.0
			},
			histPeriod: "month",
			loaded: false
		};

		this.seeIntraday = this.seeIntraday.bind(this);
		this.seeIntraweek = this.seeIntraweek.bind(this);
		this.seeIntramonth = this.seeIntramonth.bind(this);
		this.seeIntrayear = this.seeIntrayear.bind(this);
	}

	seeIntraday(){
		this.setState({histPeriod: "day"});
	}

	seeIntraweek(){
		this.setState({histPeriod: "week"});
	}

	seeIntramonth(){
		this.setState({histPeriod: "month"});
	}

	seeIntrayear(){
		this.setState({histPeriod: "year"});
	}

	componentDidMount() {
		let URL = `http://localhost:3000/api/users/${this.props.id}`;
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

	seeIntraday(){
		this.setState({histPeriod: "day"});
	}

	seeIntraweek(){
		this.setState({histPeriod: "week"});
	}

	seeIntramonth(){
		this.setState({histPeriod: "month"});
	}

	seeIntrayear(){
		this.setState({histPeriod: "year"});
	}

	render (){

		lastCloseChange = this.state.data.value - this.state.data.historyWeek[0].value;

		if (this.state.histPeriod === "day"){
			histData = this.state.data.historyDay;
		} else if (this.state.histPeriod === "week"){
			histData = this.state.data.historyWeek;
		} else if (this.state.histPeriod === "month"){
			histData = this.state.data.historyMonth;
		} else if (this.state.histPeriod === "year"){
			histData = this.state.data.historyYear;
		}





		let histList = histData.map(
			timePoint => timePoint.value
		);

		let labelList = histData.map(
			timePoint => timePoint.date
		);

		const ctx6 = document.getElementById("userHistory");
	        const userHistory = new Chart(ctx6, {
	           type: 'line',
	           data: {
		           labels: labelList,
		           datasets: [{
		               label: "Account Value",
		               data: histList.reverse(),
		               borderColor: "#3e95cd"
		            }]

	          	},
	          	options: {
	          		title: {
	          			display: true,
	          			text: 'Account History: Intra'+this.state.histPeriod
	          		},
	          		elements: {
	          			line: {
	          				tension: 0
	          			}
	          		}
	          	}
			}
		);

		return (
			<div id="accountTopRightInfo">
				<h3>
					Net position
				</h3>
				<h2>
					{this.state.loaded ? 
					"$"+commaDecimal(this.state.data.value) : 
					"Loading..."}
				</h2>
				<h4 class={ lastCloseChange > 0.0 ? 
						"changeUp" : "changeDown"
					}>
					<span class={
						lastCloseChange > 0.0 ?
						"glyphicon glyphicon-arrow-up" :
						"glyphicon glyphicon-arrow-down"
					}></span>

					{this.state.loaded ? 

					" $"+commaDecimal(Math.abs(lastCloseChange))+" "+commaDecimal(Math.abs(100.0*lastCloseChange/this.state.data.value))+"%" :

					"..."}
				</h4>
				<table id="accountTopBoxTable">
					<tr>
						<td>
							Portfolio value
						</td>
						<td><b>
							{this.state.loaded ? 
							'$'+commaDecimal(this.state.data.value - this.state.data.cash) : 
							"Waiting..."}
						</b></td>
					</tr>
					<tr>
						<td>
							Account cash
						</td>
						<td><b>
							{this.state.loaded ? 
							'$'+commaDecimal(this.state.data.cash) : 
							"Waiting..."}
						</b></td>
					</tr>
					
				</table>

				<h5>Change time period</h5>

					<table class="changeTimePeriod">

						<tr>

						<td>

							<button type="button" class="btn btn-primary btn-xs" onClick={this.seeIntraday}>
								<span class="intraToggle">
									Intraday
								</span>
							</button>

						</td>
						<td>

							<button type="button" class="btn btn-primary btn-xs" onClick={this.seeIntraweek}>
								<span class="intraToggle">
									Intraweek
								</span>
							</button>

						</td>

						</tr>
						<tr>

						<td>

							<button type="button" class="btn btn-primary btn-xs" onClick={this.seeIntramonth}>
								<span class="intraToggle">
									Intramonth
								</span>
							</button>

						</td>
						<td>

							<button type="button" class="btn btn-primary btn-xs" onClick={this.seeIntrayear}>
								<span class="intraToggle">
									Intrayear
								</span>
							</button>

						</td>

						</tr>

					</table>
			</div>
		);

	}

}
class SecurityView extends React.Component {
	constructor(props){
		super(props);
		this.state = {
			histPeriod: "week",
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
			}
		}
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
				data: json
			});
		});
	}

	render (){

		if (this.state.histPeriod === "day"){
			histData = this.state.data.historyDay;
		} else if (this.state.histPeriod === "week"){
			histData = this.state.data.historyWeek;
		} else if (this.state.histPeriod === "month"){
			histData = this.state.data.historyMonth;
		} else if (this.state.histPeriod === "year"){
			histData = this.state.data.historyYear;
		}

		let labelList = histData.map(
		point =>
			point.date
		);

		let valueList = histData.map(
		point =>
			point.price
		);

		const ctx5 = document.getElementById("securityHistory");
        const securityHistory = new Chart(ctx5, {
           type: 'line',
           data: {
	           labels: labelList,
	           datasets: [{
	               label: "Security Value",
	               data: valueList,
	               borderColor: "#3e95cd",
	               pointRadius: 0
	            }]

          	},
          	options: {
          		title: {
          			display: true
          		}
          	}

       	});

		return(
		<div>
			<div class="row">
				<div class="col-sm-3">
					{this.state.data.expret}
				</div>
				<div class="col-sm-3">
					{this.state.data.stddev}
				</div>
				<div class="col-sm-3">
					{this.state.data.lastDividend}
				</div>
				<div class="col-sm-3">
					${
						commaDecimal(this.state.data.price*this.state.data.numShares/1000000000)
					}b
				</div>
			</div>
			<div class="row">
				<div class="col-sm-3">
				</div>
				<div class="col-sm-3">
				</div>
				<div class="col-sm-3">
				</div>
				<div class="col-sm-3">
				</div>
			</div>
		</div>
		);
	}
}
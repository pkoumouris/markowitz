class UserCashTransfer extends React.Component {
	constructor(props){
		super(props);
		this.state = {
			selectedPortfolio: this.props.portfolioList[0],
			accountCash: this.props.accountCash,
			transferValue: 0.0,
			sign: 1,
			confirmable: false,
			firstPage: true,
			confirmPage: false,
			successPage: false,
			failurePage: false,
			awaitingResponse: false,
			errorMessage: "none"
		};

		this.setWithdraw = this.setWithdraw.bind(this);
		this.setDeposit = this.setDeposit.bind(this);
		this.handleTransferValueChange = this.handleTransferValueChange.bind(this);
		this.handleSelectedPortfolioChange = this.handleSelectedPortfolioChange.bind(this);
		this.firstPageClick = this.firstPageClick.bind(this);
		this.confirmClick = this.confirmClick.bind(this);
		this.checkConfirmable = this.checkConfirmable.bind(this);
		this.backToFirstPage = this.backToFirstPage.bind(this);
	}

	setWithdraw(){
		this.setState({ sign: -1 });
		this.checkConfirmable();
	}

	setDeposit(){
		this.setState({ sign: 1 });
		this.checkConfirmable();
	}

	handleTransferValueChange(event) {
		const target = event.target;
		const value = target.value;
		const name = target.name;

		if (!(value>0)){
			this.setState({
				transferValue: 0.0
			});
		} else {

			this.setState({
				transferValue: value
			});

		}

		this.checkConfirmable();

	}

	handleSelectedPortfolioChange(event) {
		const target = event.target;
		const value = target.value;
		const name = target.name;

		this.setState({
			selectedPortfolio: String(value)
		});

		this.checkConfirmable();
	}

	firstPageClick() {
		if (this.state.confirmable){
			this.setState({
				firstPage: false,
				confirmPage: true
			});
		}

	}

	confirmClick() {

		this.setState({awaitingResponse: true})

		let URL = `http://localhost:3000/api/users/${this.props.id}`;
		let component = this;

		SD = String(this.state.stdDev);

		let postData = {
			id: this.props.id,
			type: "cashTransfer",
			data: {
				portfolioName: this.state.selectedPortfolio,
				value: this.state.transferValue*this.state.sign
			}
		};

		fetch(URL,
			{
				headers: {
					'Accept': 'application/json',
					'Content-Type': 'application/json'
				},
				method: 'PATCH',
				body: JSON.stringify(postData)
			}
		)
		.then( (response) => {
			if (response.ok){
				return response.json();
			}
			throw new Error('Request fail');
		})
		.then( json => {

			if (json.status === 200){
				this.setState({
					successPage: true,
					confirmPage: false
				});
			} else {
				this.setState({
					failurePage: true,
					confirmPage: false,
					errorMessage: json.error
				});
			}
		});

		this.setState({awaitingResponse: false});

	}

	backToFirstPage() {
		this.setState({
			firstPage: true,
			confirmPage: false,
			successPage: false,
			failurePage: false
		});
	}

	checkConfirmable() {

		

		if (this.state.transferValue > 0) {

			if (this.state.sign > 0) {
				/*if (this.state.accountCash < this.state.transferValue) {
					this.setState({confirmable: false});
				} else {
					this.setState({confirmable: true});
				}*/
				this.setState({confirmable: true});
			} else {
				/*pf_index = (this.props.portfolioCashList).indexOf(this.props.selectedPortfolio);

				if (this.props.portfolioCashList[pf_index] < this.state.transferValue) {
					this.setState({confirmable: false});
				} else {
					this.setState({confirmable: true});
				}*/

				this.setState({confirmable: true});
			}

		} else {
			this.setState({confirmable: false});
		}

	}

	render() {

		let secList = this.props.portfolioList.map(
			pointSec => 
			<option value={pointSec}>
				{pointSec}
			</option>
		);

		let confirmationText = (

			<table id="transferConfirmationText">
				<tr>
					<td>
						Transfer value
					</td>
					<td><b>
						{"$"+commaDecimal(this.state.transferValue)}
					</b></td>
				</tr>
				<tr>
					<td>
						{this.state.sign > 0 ?
							"Deposit to " :
							"Withdraw from "}
					</td>
					<td><b>
						{this.state.selectedPortfolio}
					</b></td>
				</tr>
			</table>

		);

		let confirmButton = (
			<button
			id="cashTransferButtonSpecifics"
			type = "button"
			onClick = {this.confirmClick} 
			className = "cashTransferBoxButtonTeal" >
				Confirm
			</button>
		);

		let backToFirstPageButton = (
			<button 
			type="button" 
			onClick = {this.backToFirstPage} 
			className = {this.state.successPage ? "cashTransferBoxButtonGreen" : "cashTransferBoxButtonTeal" }
			>
				Back
			</button>
		)

		let transferButtonEnabled = (
			<button type="button" 
				className="cashTransferBoxButtonTeal"
				onClick={this.firstPageClick} >
					Transfer
			</button>
		);

		let transferButtonDisabled = (
			<button type="button"
				className="cashTransferBoxButtonDisabled" 
				disabled>
				Transfer
			</button>
		);

		let statusCard;

		if (this.state.successPage) {
			statusCard = "accountCashTransferSuccess";
		} else if (this.state.failurePage) {
			statusCard = "accountCashTransferFailure";
		} else {
			statusCard = "accountCashTransfer";
		}

		let message;

		if (this.state.firstPage) {
			message = (
				<p>
					Once you deposit cash into your a portfolio, you can allocate it to securities.
				</p>
			);
		} else if (this.state.confirmPage) {
			message = (
				<p>
					Please review your proposed cash transfer.
				</p>
			);
		} else if (this.state.successPage) {
			message = (
				<p>
					Your transfer was successful. Refresh the page or go to your portfolio to see the change.
				</p>
			);
		} else if (this.state.failurePage) {
			message = (
				<div>
					<p>
						Your transfer was unsuccessful.
					</p>
					<p>
						{this.state.errorMessage}
					</p>
				</div>
			);
		}

		return(
			<div className="col-sm-5" id={statusCard} >

				<h3>

					{(this.state.firstPage) ? 
					"Transfer cash to a portfolio" : ""}

					{this.state.confirmPage ? 
					"Confirm transfer" : ""}

					{this.state.successPage ? 
					"Successful transfer" : 
					""}

					{this.state.failurePage ? 
					"Failed transfer" :
					""}

				</h3>

				<span id="cashTransferTick" class={this.state.successPage ? "glyphicon glyphicon-tick" : ""}></span>
				
				{message}

				<h4>
					{this.state.firstPage ? "Select your portfolio" : ""}
				</h4>

				{this.state.confirmPage ? confirmationText : ""}



				<ul className="nav nav-pills" id={this.state.firstPage ? "cashTransferTogglePill" : "hideMe"}>
					<li className={this.state.sign > 0 ?
								"active" : "" }>
						<button 

						id={this.state.sign > 0 ? "cashTransferToggleActive": "cashTransferToggle" }

						onClick={this.setDeposit}

						>
							Deposit
						</button>
					</li>
					<li className={this.state.sign < 0 ?
								"active" : "" }>
						<button 

						id={this.state.sign < 0 ? "cashTransferToggleActive" : 
						"cashTransferToggle" }

						onClick={this.setWithdraw}

						>
							Withdraw
						</button>
					</li>
				</ul>
				
				<form id={this.state.firstPage ? 
				"cashTransferForm" : "hideMe"}>
					<label>
						<select id="formPortfolioList"
						onChange={this.handleSelectedPortfolioChange} >
							{secList}
						</select>
					</label><br />
						Amount: $
						<input 
						name="transferValue" 
						type="number" 
						onChange={this.handleTransferValueChange} /><br />
					{this.state.confirmable ? 
					transferButtonEnabled : 
					transferButtonDisabled}
				</form>

				{!this.state.firstPage ? backToFirstPageButton : ""}
				{this.state.confirmPage ? confirmButton : ""}

				<h4>
					{this.state.confirmPage && this.state.awaitingResponse ?
					"Loading..." : ""}
				</h4>

			</div>
		);

	}
}